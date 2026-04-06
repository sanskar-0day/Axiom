<script>
  import { onMount } from 'svelte'
  import { request } from '@axiom/ws-client'
  import OptionNode from './OptionNode.svelte'

  let tree = []
  let loading = true

  onMount(async () => {
    try {
      tree = await request('get_option_tree', { root: '' })
    } catch (err) {
      console.error('Failed to load options:', err)
    } finally {
      loading = false
    }
  })
</script>

<div class="option-tree">
  {#if loading}
    <p class="loading-text">Loading NixOS options...</p>
  {:else}
    {#each tree as node}
      <OptionNode {node} depth={0} />
    {/each}
  {/if}
</div>

<style>
  .option-tree {
    padding: var(--space-4);
    overflow-y: auto;
    flex: 1;
  }

  .loading-text {
    color: var(--color-text-tertiary);
    text-align: center;
    padding: var(--space-8);
  }
</style>
