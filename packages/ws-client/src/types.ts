export interface Package {
  name: string
  version: string
  description: string
}

export interface NixOption {
  name: string
  type: string
  description: string
  default: string
  example?: string
}

export interface GraphNode {
  id: string
  label: string
  type: string
}

export interface GraphEdge {
  source: string
  target: string
  type: string
}

export interface GraphData {
  nodes: GraphNode[]
  edges: GraphEdge[]
}

export interface SystemInfo {
  hostname: string
  nixosVersion: string
  kernel: string
  uptime: string
  cpu: string
  memoryTotal: string
  memoryUsed: string
}

export interface RebuildProgress {
  active: boolean
  percent: number
  message: string
  lines: string[]
}

export type RequestType =
  | 'search_packages'
  | 'install_package'
  | 'remove_package'
  | 'get_option'
  | 'set_option'
  | 'get_option_tree'
  | 'get_dependencies'
  | 'get_system_info'
  | 'rebuild'
  | 'list_installed'
  | 'get_profiles'
  | 'apply_profile'

export interface WsMessage {
  id: string
  type: string
  [key: string]: any
}