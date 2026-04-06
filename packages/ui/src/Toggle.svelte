<script>
  export let checked = false
  export let disabled = false
  export let label = ''
</script>

<label class="toggle-wrapper" class:disabled>
  <button
    class="toggle"
    class:checked
    {disabled}
    role="switch"
    aria-checked={checked}
    on:click={() => { if (!disabled) checked = !checked }}
  >
    <span class="toggle-thumb" />
  </button>
  {#if label}
    <span class="toggle-label">{label}</span>
  {/if}
</label>

<style>
  .toggle-wrapper {
    display: inline-flex;
    align-items: center;
    gap: var(--space-3);
    cursor: pointer;
  }

  .toggle-wrapper.disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }

  .toggle {
    position: relative;
    width: 44px;
    height: 24px;
    background: var(--color-bg-3);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-full);
    transition: all var(--transition-normal);
    padding: 0;
  }

  .toggle.checked {
    background: var(--color-primary);
    border-color: var(--color-primary);
  }

  .toggle-thumb {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 18px;
    height: 18px;
    background: white;
    border-radius: 50%;
    transition: transform var(--transition-normal);
  }

  .toggle.checked .toggle-thumb {
    transform: translateX(20px);
  }

  .toggle-label {
    font-size: var(--text-sm);
    color: var(--color-text-secondary);
  }
</style>
