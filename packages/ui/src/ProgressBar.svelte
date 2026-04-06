<script>
  export let percent = 0
  export let size = 'md'
  export let showLabel = false

  $: clampedPercent = Math.max(0, Math.min(100, percent))
</script>

<div class="progress-wrapper">
  <div class="progress-track progress-{size}">
    <div class="progress-fill" style="width: {clampedPercent}%" />
  </div>
  {#if showLabel}
    <span class="progress-label">{Math.round(clampedPercent)}%</span>
  {/if}
</div>

<style>
  .progress-wrapper {
    display: flex;
    align-items: center;
    gap: var(--space-3);
  }

  .progress-track {
    flex: 1;
    background: var(--color-bg-3);
    border-radius: var(--radius-full);
    overflow: hidden;
  }

  .progress-sm { height: 4px; }
  .progress-md { height: 8px; }

  .progress-fill {
    height: 100%;
    background: var(--color-primary);
    border-radius: var(--radius-full);
    transition: width 0.3s ease;
  }

  .progress-label {
    font-size: var(--text-sm);
    color: var(--color-text-secondary);
    min-width: 3em;
    text-align: right;
    font-variant-numeric: tabular-nums;
  }
</style>
