<script lang="ts">
  import { onMount } from 'svelte';
  import { gsap } from 'gsap';

  onMount(() => {
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (reduceMotion) {
      return;
    }

    const timeline = gsap.timeline({ defaults: { ease: 'power3.out' } });

    timeline
      .from('.hero-backdrop', {
        opacity: 0,
        duration: 1.2
      })
      .from(
        '.hero-kicker',
        {
          opacity: 0,
          y: 24,
          filter: 'blur(8px)',
          duration: 0.7
        },
        '-=0.5'
      )
      .from(
        '.hero-title',
        {
          opacity: 0,
          y: 40,
          filter: 'blur(14px)',
          duration: 1.1
        },
        '-=0.25'
      )
      .from(
        '.hero-subtitle',
        {
          opacity: 0,
          y: 28,
          filter: 'blur(10px)',
          duration: 0.9
        },
        '-=0.65'
      );
  });
</script>

<svelte:head>
  <title>Axiom OS | Work in Progress</title>
  <meta
    name="description"
    content="Axiom OS is a next-generation, Nix-based declarative operating system built with Nim and an embedded graph database."
  />
</svelte:head>

<main class="page">
  <div class="hero-backdrop" aria-hidden="true">
    <div class="graph-placeholder" aria-label="Future Three.js node-graph render target"></div>
  </div>

  <section class="hero" aria-label="Axiom OS Work in Progress">
    <p class="hero-kicker">Work in Progress</p>
    <h1 class="hero-title">Axiom OS</h1>
    <p class="hero-subtitle">The World's Best Agentic Declarative Operating System</p>
  </section>
</main>

<style>
  :global(html),
  :global(body) {
    margin: 0;
    min-height: 100%;
    background: #04050a;
    color: #f4f7ff;
    font-family: 'Sora', 'Space Grotesk', 'Segoe UI', sans-serif;
  }

  :global(*) {
    box-sizing: border-box;
  }

  .page {
    position: relative;
    min-height: 100dvh;
    overflow: hidden;
    display: grid;
    place-items: center;
    background:
      radial-gradient(circle at 15% 20%, rgba(56, 83, 178, 0.35), transparent 42%),
      radial-gradient(circle at 85% 82%, rgba(20, 184, 166, 0.2), transparent 34%),
      linear-gradient(165deg, #070a14 0%, #030308 48%, #05080e 100%);
  }

  .hero-backdrop {
    position: absolute;
    inset: 0;
    display: grid;
    place-items: center;
    padding: 2rem;
    pointer-events: none;
  }

  .graph-placeholder {
    width: min(88vw, 1080px);
    height: min(65vh, 620px);
    border-radius: 20px;
    border: 1px solid rgba(166, 199, 255, 0.22);
    background:
      linear-gradient(to right, rgba(125, 158, 255, 0.08) 1px, transparent 1px),
      linear-gradient(to bottom, rgba(125, 158, 255, 0.08) 1px, transparent 1px),
      radial-gradient(circle at 30% 20%, rgba(60, 141, 255, 0.18), transparent 40%),
      rgba(9, 13, 24, 0.68);
    background-size: 40px 40px, 40px 40px, auto, auto;
    box-shadow:
      0 0 0 1px rgba(95, 145, 255, 0.12) inset,
      0 28px 80px rgba(0, 0, 0, 0.5),
      0 0 64px rgba(70, 128, 255, 0.22);
  }

  .hero {
    position: relative;
    z-index: 1;
    text-align: center;
    width: min(92vw, 860px);
    padding: 2rem;
  }

  .hero-kicker {
    margin: 0;
    text-transform: uppercase;
    letter-spacing: 0.24em;
    font-size: clamp(0.75rem, 0.75vw + 0.6rem, 1rem);
    color: rgba(180, 207, 255, 0.75);
  }

  .hero-title {
    margin: 0.55rem 0 0;
    font-size: clamp(2.8rem, 9vw, 7rem);
    line-height: 0.95;
    letter-spacing: 0.02em;
    font-weight: 700;
    text-shadow:
      0 0 12px rgba(132, 176, 255, 0.75),
      0 0 38px rgba(68, 122, 255, 0.5),
      0 0 80px rgba(68, 122, 255, 0.28);
  }

  .hero-subtitle {
    margin: 1.25rem auto 0;
    max-width: 700px;
    font-size: clamp(1rem, 1.25vw + 0.85rem, 1.55rem);
    line-height: 1.45;
    color: rgba(226, 234, 255, 0.9);
  }

  @media (max-width: 640px) {
    .hero {
      padding: 1.5rem 1.15rem;
    }

    .graph-placeholder {
      height: 58vh;
      border-radius: 14px;
      background-size: 30px 30px, 30px 30px, auto, auto;
    }
  }
</style>
