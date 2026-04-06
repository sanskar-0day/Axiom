<script>
  import { connected, rebuildProgress, isRebuilding } from '@axiom/ws-client/src/stores'
  import { Spinner } from '@axiom/ui'
</script>

<footer class="statusbar">
  <div class="status-left">
    <span class="connection-dot" class:connected={$connected}></span>
    <span>{$connected ? 'Connected' : 'Disconnected'}</span>
  </div>

  <div class="status-center">
    {#if $isRebuilding}
      <Spinner size="sm" />
      <span>{$rebuildProgress.message}</span>
      <span class="rebuild-percent">{$rebuildProgress.percent}%</span>
    {/if}
  </div>

  <div class="status-right">
    <span>Axiom OS v0.1.0</span>
  </div>
</footer>

<style>
  .statusbar {
    position: fixed;
    bottom: 0;
    left: var(--sidebar-width);
    right: 0;
    height: var(--statusbar-height);
    background: var(--color-bg-1);
    border-top: 1px solid var(--color-border);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 var(--space-4);
    font-size: var(--text-xs);
    color: var(--color-text-tertiary);
    z-index: 100;
  }

  .status-left, .status-center, .status-right {
    display: flex;
    align-items: center;
    gap: var(--space-2);
  }

  .connection-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: var(--color-error);
  }

  .connection-dot.connected {
    background: var(--color-success);
  }

  .rebuild-percent {
    font-variant-numeric: tabular-nums;
  }
</style>
