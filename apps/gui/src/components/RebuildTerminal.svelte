<script>
  import { rebuildProgress } from '@axiom/ws-client/src/stores'
  import { ProgressBar } from '@axiom/ui'

  let terminalEl

  $: if (terminalEl && $rebuildProgress.lines.length) {
    terminalEl.scrollTop = terminalEl.scrollHeight
  }
</script>

<div class="rebuild-terminal">
  <div class="terminal-header">
    <span>System Rebuild</span>
    {#if $rebuildProgress.active}
      <ProgressBar percent={$rebuildProgress.percent} showLabel size="sm"></ProgressBar>
    {/if}
  </div>
  <div class="terminal-output" bind:this={terminalEl}>
    {#each $rebuildProgress.lines as line}
      <div class="terminal-line">{line}</div>
    {/each}
    {#if !$rebuildProgress.active && $rebuildProgress.lines.length === 0}
      <div class="terminal-line dimmed">No rebuild in progress.</div>
    {/if}
  </div>
</div>

<style>
  .rebuild-terminal {
    display: flex;
    flex-direction: column;
    height: 100%;
    background: var(--color-bg-0);
  }

  .terminal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: var(--space-3) var(--space-4);
    background: var(--color-bg-1);
    border-bottom: 1px solid var(--color-border);
    font-size: var(--text-sm);
    font-weight: 600;
  }

  .terminal-output {
    flex: 1;
    overflow-y: auto;
    padding: var(--space-4);
    font-family: var(--font-mono);
    font-size: var(--text-sm);
    line-height: 1.6;
  }

  .terminal-line {
    color: var(--color-text-secondary);
    white-space: pre-wrap;
    word-break: break-all;
  }

  .terminal-line.dimmed {
    color: var(--color-text-tertiary);
  }
</style>
