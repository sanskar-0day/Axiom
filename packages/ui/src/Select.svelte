<script>
  export let value = ''
  export let options = []
  export let placeholder = 'Select...'
  export let disabled = false
</script>

<select class="select" bind:value {disabled} on:change>
  {#if placeholder}
    <option value="" disabled selected>{placeholder}</option>
  {/if}
  {#each options as opt}
    <option value={opt.value}>{opt.label}</option>
  {/each}
</select>

<style>
  .select {
    width: 100%;
    padding: var(--space-2) var(--space-4);
    background: var(--color-bg-0);
    color: var(--color-text-primary);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    outline: none;
    font-size: var(--text-base);
    cursor: pointer;
    transition: border-color var(--transition-fast);
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12' fill='none'%3E%3Cpath d='M3 4.5L6 7.5L9 4.5' stroke='%238080a0' stroke-width='1.5' stroke-linecap='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
    padding-right: 36px;
  }

  .select:focus {
    border-color: var(--color-border-focus);
    box-shadow: 0 0 0 3px var(--color-primary-subtle);
  }
</style>
