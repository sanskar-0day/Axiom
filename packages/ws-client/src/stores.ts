import { writable, derived } from 'svelte/store'
import type { Package, SystemInfo, RebuildProgress, GraphData } from './types'

export const connected = writable(false)
export const currentView = writable<string>('packages')

export const searchQuery = writable('')
export const searchResults = writable<Package[]>([])
export const installedPackages = writable<string[]>([])

export const rebuildProgress = writable<RebuildProgress>({
  active: false,
  percent: 0,
  message: '',
  lines: []
})

export const systemInfo = writable<SystemInfo | null>(null)
export const graphData = writable<GraphData>({ nodes: [], edges: [] })

export const isRebuilding = derived(rebuildProgress, $p => $p.active)