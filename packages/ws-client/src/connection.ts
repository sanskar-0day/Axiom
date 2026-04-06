type MessageHandler = (data: any) => void

const pendingRequests = new Map<string, {
  resolve: (data: any) => void
  reject: (error: any) => void
}>()

const listeners = new Map<string, MessageHandler[]>()
let socket: WebSocket | null = null
let reconnectTimer: ReturnType<typeof setTimeout> | null = null
let reconnectAttempts = 0
const MAX_RECONNECT_DELAY = 10000

function generateId(): string {
  return Math.random().toString(36).substring(2, 10) +
         Date.now().toString(36)
}

export function connect(url: string = 'ws://localhost:1337'): void {
  if (socket?.readyState === WebSocket.OPEN) return

  socket = new WebSocket(url)

  socket.onopen = () => {
    reconnectAttempts = 0
    emit('connected', {})
  }

  socket.onmessage = (event: MessageEvent) => {
    let msg: any
    try {
      msg = JSON.parse(event.data)
    } catch {
      return
    }

    if (msg.id && pendingRequests.has(msg.id)) {
      const pending = pendingRequests.get(msg.id)!
      if (msg.type === 'result') {
        pending.resolve(msg.data)
        pendingRequests.delete(msg.id)
      } else if (msg.type === 'error') {
        pending.reject(new Error(msg.message))
        pendingRequests.delete(msg.id)
      }
    }

    emit(msg.type, msg)
    if (msg.id) {
      emit(`${msg.type}:${msg.id}`, msg)
    }
  }

  socket.onclose = () => {
    emit('disconnected', {})
    const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), MAX_RECONNECT_DELAY)
    reconnectAttempts++
    reconnectTimer = setTimeout(() => connect(url), delay)
  }

  socket.onerror = () => {
    // onclose will fire after this
  }
}

export function disconnect(): void {
  if (reconnectTimer) {
    clearTimeout(reconnectTimer)
    reconnectTimer = null
  }
  if (socket) {
    socket.close()
    socket = null
  }
}

export function request(type: string, payload: Record<string, any> = {}): Promise<any> {
  return new Promise((resolve, reject) => {
    if (!socket || socket.readyState !== WebSocket.OPEN) {
      reject(new Error('Not connected to engine'))
      return
    }

    const id = generateId()
    pendingRequests.set(id, { resolve, reject })

    socket.send(JSON.stringify({ id, type, ...payload }))

    setTimeout(() => {
      if (pendingRequests.has(id)) {
        pendingRequests.delete(id)
        reject(new Error(`Request ${type} timed out`))
      }
    }, 300_000)
  })
}

export function on(event: string, handler: MessageHandler): void {
  if (!listeners.has(event)) {
    listeners.set(event, [])
  }
  listeners.get(event)!.push(handler)
}

export function off(event: string, handler: MessageHandler): void {
  const handlers = listeners.get(event)
  if (handlers) {
    listeners.set(event, handlers.filter(h => h !== handler))
  }
}

function emit(event: string, data: any): void {
  listeners.get(event)?.forEach(h => h(data))
}