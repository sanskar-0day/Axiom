<script>
  export let message = ''
  export let type = 'info'
  export let visible = false
  export let duration = 3000

  $: if (visible && duration > 0) {
    setTimeout(() => { visible = false }, duration)
  }
</script>

{#if visible}
  <div class="toast toast-{type}">
    <span class="toast-icon">
      {#if type === 'success'}&#10003;
      {:else if type === 'error'}&#10007;
      {:else if type === 'warning'}&#9888;
      {:else}&#9432;
      {/if}
    </span>
    <span class="toast-message">{message}</span>
  </div>
{/if}

<style>
  .toast {
    position: fixed;
    bottom: 24px;
    right: 24px;
    display: flex;
    align-items: center;
    gap: var(--space-3);
    padding: var(--space-3) var(--space-5);
    border-radius: var(--radius-lg);
    font-size: var(--text-sm);
    z-index: 2000;
    animation: fadeInUp 0.25s ease;
    box-shadow: var(--shadow-lg);
  }

  .toast-success { background: var(--color-success-subtle); color: var(--color-success); border: 1px solid var(--color-success); }
  .toast-error   { background: var(--color-error-subtle);   color: var(--color-error);   border: 1px solid var(--color-error); }
  .toast-warning { background: var(--color-warning-subtle); color: var(--color-warning); border: 1px solid var(--color-warning); }
  .toast-info    { background: var(--color-info-subtle);    color: var(--color-info);    border: 1px solid var(--color-info); }

  .toast-icon { font-size: var(--text-lg); }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }
</style>
