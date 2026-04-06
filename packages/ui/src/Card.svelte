<script>
  export let padding = 'md'
  export let hoverable = false
</script>

<div class="card padding-{padding}" class:hoverable>
  <slot />
</div>

<style>
  .card {
    background: var(--color-bg-1);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    transition: all var(--transition-normal);
  }

  .hoverable:hover {
    border-color: var(--color-border-hover);
    background: var(--color-bg-2);
  }

  .padding-none { padding: 0; }
  .padding-sm { padding: var(--space-3); }
  .padding-md { padding: var(--space-4); }
  .padding-lg { padding: var(--space-6); }
</style>
