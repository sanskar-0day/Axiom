<script>
  import RebuildTerminal from '../components/RebuildTerminal.svelte'
  import { Button } from '@axiom/ui'
  import { request } from '@axiom/ws-client'
  import { rebuildProgress } from '@axiom/ws-client/src/stores'
  import { on, off } from '@axiom/ws-client'

  async function triggerRebuild() {
    const handler = (msg) => {
      if (msg.type === 'progress') {
        rebuildProgress.update(p => ({
          active: true,
          percent: msg.percent,
          message: msg.message,
          lines: [...p.lines, msg.message]
        }))
      }
    }
    on('progress', handler)

    try {
      rebuildProgress.set({ active: true, percent: 0, message: 'Starting rebuild...', lines: [] })
      await request('rebuild')
      rebuildProgress.update(p => ({ ...p, active: false, percent: 100, message: 'Complete' }))
    } catch (err) {
      rebuildProgress.update(p => ({
        ...p,
        active: false,
        message: `Error: ${err}`
      }))
    } finally {
      off('progress', handler)
    }
  }
</script>

<div class="terminal-view">
  <div class="terminal-actions">
    <Button on:click={triggerRebuild} loading={$rebuildProgress.active}>
      Rebuild System
    </Button>
  </div>
  <RebuildTerminal />
</div>

<style>
  .terminal-view {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .terminal-actions {
    padding: var(--space-4);
    border-bottom: 1px solid var(--color-border);
  }
</style>
