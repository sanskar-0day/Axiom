<script>
  export let variant = 'primary'
  export let size = 'md'
  export let disabled = false
  export let loading = false
  export let fullWidth = false
</script>

<button
  class="btn btn-{variant} btn-{size}"
  class:full-width={fullWidth}
  disabled={disabled || loading}
  on:click
  on:mouseenter
  on:mouseleave
>
  {#if loading}
    <span class="spinner-inline" />
  {/if}
  <slot />
</button>

<style>
  .btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: var(--space-2);
    border: 1px solid transparent;
    border-radius: var(--radius-md);
    font-weight: 500;
    cursor: pointer;
    transition: all var(--transition-fast);
    white-space: nowrap;
    user-select: none;
  }

  .btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .btn-primary {
    background: var(--color-primary);
    color: white;
    border-color: var(--color-primary);
  }
  .btn-primary:hover:not(:disabled) {
    background: var(--color-primary-hover);
    box-shadow: var(--shadow-glow);
  }

  .btn-secondary {
    background: var(--color-bg-2);
    color: var(--color-text-primary);
    border-color: var(--color-border);
  }
  .btn-secondary:hover:not(:disabled) {
    background: var(--color-bg-3);
    border-color: var(--color-border-hover);
  }

  .btn-danger {
    background: var(--color-error);
    color: white;
    border-color: var(--color-error);
  }
  .btn-danger:hover:not(:disabled) {
    background: #ef4444;
  }

  .btn-ghost {
    background: transparent;
    color: var(--color-text-secondary);
  }
  .btn-ghost:hover:not(:disabled) {
    background: var(--color-bg-2);
    color: var(--color-text-primary);
  }

  .btn-sm {
    padding: var(--space-1) var(--space-3);
    font-size: var(--text-sm);
  }
  .btn-md {
    padding: var(--space-2) var(--space-4);
    font-size: var(--text-base);
  }
  .btn-lg {
    padding: var(--space-3) var(--space-6);
    font-size: var(--text-lg);
  }

  .full-width {
    width: 100%;
  }

  .spinner-inline {
    width: 1em;
    height: 1em;
    border: 2px solid transparent;
    border-top-color: currentColor;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>
