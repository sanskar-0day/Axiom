<script>
  export let value = ''
  export let placeholder = ''
  export let type = 'text'
  export let disabled = false
  export let size = 'md'
</script>

<input
  class="input input-{size}"
  type="text"
  {placeholder}
  {disabled}
  bind:value
  on:input
  on:focus
  on:blur
  on:keydown
/>

<style>
  .input {
    width: 100%;
    background: var(--color-bg-0);
    color: var(--color-text-primary);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    outline: none;
    transition: border-color var(--transition-fast);
  }

  .input:focus {
    border-color: var(--color-border-focus);
    box-shadow: 0 0 0 3px var(--color-primary-subtle);
  }

  .input::placeholder {
    color: var(--color-text-tertiary);
  }

  .input:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .input-sm { padding: var(--space-1) var(--space-3); font-size: var(--text-sm); }
  .input-md { padding: var(--space-2) var(--space-4); font-size: var(--text-base); }
  .input-lg { padding: var(--space-3) var(--space-5); font-size: var(--text-lg); }
</style>
