<script>
  import { Icon, Toggle } from '@axiom/ui'
  import { request } from '@axiom/ws-client'

  export let node
  export let depth = 0

  let expanded = false
  let boolValue = node.value === true || node.value === 'true'

  async function toggleOption() {
    boolValue = !boolValue
    try {
      await request('set_option', {
        path: node.name,
        value: boolValue ? 'true' : 'false'
      })
    } catch (err) {
      boolValue = !boolValue
      console.error('Failed to set option:', err)
    }
  }
</script>

<div class="option-node" style="padding-left: {depth * 20}px">
  <button class="option-header" on:click={() => expanded = !expanded}>
    {#if node.children?.length}
      <span class="expand-icon" class:expanded>
        <Icon name="chevron-right" size={14} />
      </span>
    {:else}
      <span class="expand-icon-spacer"></span>
    {/if}

    <span class="option-name">{node.name}</span>

    {#if node.type === 'boolean'}
      <span class="option-toggle" on:click|stopPropagation>
        <Toggle checked={boolValue} on:click={toggleOption} />
      </span>
    {:else}
      <span class="option-type">{node.type}</span>
    {/if}
  </button>

  {#if expanded && node.children}
    {#each node.children as child}
      <svelte:self node={child} depth={depth + 1} />
    {/each}
  {/if}
</div>

<style>
  .option-node {
    border-bottom: 1px solid var(--color-border);
  }

  .option-header {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    padding: var(--space-2) var(--space-3);
    background: transparent;
    border: none;
    width: 100%;
    text-align: left;
    color: var(--color-text-primary);
    font-size: var(--text-sm);
    transition: background var(--transition-fast);
  }

  .option-header:hover {
    background: var(--color-bg-2);
  }

  .expand-icon {
    transition: transform var(--transition-fast);
    display: flex;
    color: var(--color-text-tertiary);
  }

  .expand-icon.expanded {
    transform: rotate(90deg);
  }

  .expand-icon-spacer {
    width: 14px;
  }

  .option-name {
    flex: 1;
    font-family: var(--font-mono);
    font-size: var(--text-sm);
  }

  .option-type {
    font-size: var(--text-xs);
    color: var(--color-text-tertiary);
    padding: 0 var(--space-2);
    background: var(--color-bg-3);
    border-radius: var(--radius-sm);
  }

  .option-toggle {
    display: flex;
    align-items: center;
  }
</style>
