<script>
  import { onMount } from 'svelte'
  import { connect, on } from '@axiom/ws-client'
  import { connected } from '@axiom/ws-client/src/stores'
  import { currentRoute } from './lib/router'
  import Sidebar from './components/Sidebar.svelte'
  import StatusBar from './components/StatusBar.svelte'
  import PackagesView from './views/PackagesView.svelte'
  import OptionsView from './views/OptionsView.svelte'
  import GraphView from './views/GraphView.svelte'
  import TerminalView from './views/TerminalView.svelte'
  import SettingsView from './views/SettingsView.svelte'

  onMount(() => {
    connect()

    on('connected', () => {
      connected.set(true)
    })

    on('disconnected', () => {
      connected.set(false)
    })
  })
</script>

<Sidebar />

<main class="main-content">
  {#if $currentRoute === 'packages'}
    <PackagesView />
  {:else if $currentRoute === 'options'}
    <OptionsView />
  {:else if $currentRoute === 'graph'}
    <GraphView />
  {:else if $currentRoute === 'terminal'}
    <TerminalView />
  {:else if $currentRoute === 'settings'}
    <SettingsView />
  {/if}
</main>

<StatusBar />

<style>
  .main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    margin-bottom: var(--statusbar-height);
  }
</style>
