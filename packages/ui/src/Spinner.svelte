<script>
  export let size = 'md'
</script>

<span class="spinner spinner-{size}" />

<style>
  .spinner {
    display: inline-block;
    border: 2px solid var(--color-bg-3);
    border-top-color: var(--color-primary);
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
  }

  .spinner-sm { width: 16px; height: 16px; }
  .spinner-md { width: 24px; height: 24px; }
  .spinner-lg { width: 40px; height: 40px; border-width: 3px; }

  @keyframes spin {
    to { transform: rotate(360deg); }
  }
</style>
