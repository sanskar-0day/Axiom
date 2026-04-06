<script>
  export let open = false
  export let title = ''

  function close() {
    open = false
  }

  function handleKeydown(e) {
    if (e.key === 'Escape') close()
  }
</script>

<svelte:window on:keydown={handleKeydown} />

{#if open}
  <div class="overlay" on:click={close}>
    <div class="modal" on:click|stopPropagation role="dialog" aria-modal="true">
      {#if title}
        <div class="modal-header">
          <h3>{title}</h3>
          <button class="close-btn" on:click={close}>x</button>
        </div>
      {/if}
      <div class="modal-body">
        <slot />
      </div>
      {#if $$slots.footer}
        <div class="modal-footer">
          <slot name="footer" />
        </div>
      {/if}
    </div>
  </div>
{/if}

<style>
  .overlay {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.6);
    backdrop-filter: blur(4px);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    animation: fadeIn 0.15s ease;
  }

  .modal {
    background: var(--color-bg-1);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-xl);
    min-width: 400px;
    max-width: 90vw;
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: var(--shadow-lg);
    animation: fadeInUp 0.2s ease;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--space-4) var(--space-6);
    border-bottom: 1px solid var(--color-border);
  }

  .modal-header h3 {
    font-size: var(--text-lg);
    margin: 0;
  }

  .close-btn {
    background: none;
    border: none;
    color: var(--color-text-tertiary);
    font-size: var(--text-xl);
    padding: var(--space-1);
    line-height: 1;
  }

  .close-btn:hover {
    color: var(--color-text-primary);
  }

  .modal-body {
    padding: var(--space-6);
  }

  .modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: var(--space-3);
    padding: var(--space-4) var(--space-6);
    border-top: 1px solid var(--color-border);
  }

  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(10px) scale(0.98); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
</style>
