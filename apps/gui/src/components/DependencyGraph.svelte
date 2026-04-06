<script>
  import { onMount, onDestroy } from 'svelte'
  import * as THREE from 'three'
  import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
  import { gsap } from 'gsap'
  import { graphData } from '@axiom/ws-client/src/stores'
  import { request } from '@axiom/ws-client'

  let container
  let scene
  let camera
  let renderer
  let controls
  let animationId
  let nodeMeshes = new Map()

  onMount(async () => {
    initScene()

    try {
      const data = await request('get_dependencies', { option: 'services' })
      graphData.set(data)
    } catch (err) {
      console.error('Failed to load graph:', err)
    }

    animate()
  })

  onDestroy(() => {
    if (animationId) cancelAnimationFrame(animationId)
    renderer?.dispose()
  })

  function initScene() {
    scene = new THREE.Scene()
    scene.background = new THREE.Color(0x080810)

    camera = new THREE.PerspectiveCamera(
      60,
      container.clientWidth / container.clientHeight,
      0.1,
      1000
    )
    camera.position.set(0, 0, 50)

    renderer = new THREE.WebGLRenderer({ antialias: true })
    renderer.setSize(container.clientWidth, container.clientHeight)
    renderer.setPixelRatio(window.devicePixelRatio)
    container.appendChild(renderer.domElement)

    controls = new OrbitControls(camera, renderer.domElement)
    controls.enableDamping = true
    controls.dampingFactor = 0.05

    scene.add(new THREE.AmbientLight(0x404060, 0.6))
    const pointLight = new THREE.PointLight(0x8b5cf6, 1.5, 100)
    pointLight.position.set(10, 15, 10)
    scene.add(pointLight)
  }

  function animate() {
    animationId = requestAnimationFrame(animate)
    controls.update()
    renderer.render(scene, camera)
  }

  $: if (scene && $graphData.nodes.length > 0) {
    buildGraph($graphData)
  }

  function buildGraph(data) {
    nodeMeshes.forEach(m => scene.remove(m))
    nodeMeshes.clear()

    const positions = layoutNodes(data.nodes, data.edges)

    for (const node of data.nodes) {
      const color = node.type === 'service' ? 0x8b5cf6 :
                    node.type === 'network' ? 0x3b82f6 :
                    0x34d399

      const geo = new THREE.SphereGeometry(0.4, 16, 16)
      const mat = new THREE.MeshPhongMaterial({
        color,
        emissive: color,
        emissiveIntensity: 0.2,
        transparent: true,
        opacity: 0.9
      })
      const mesh = new THREE.Mesh(geo, mat)
      const pos = positions.get(node.id) || { x: 0, y: 0, z: 0 }
      mesh.position.set(pos.x, pos.y, pos.z)
      mesh.userData = node
      scene.add(mesh)
      nodeMeshes.set(node.id, mesh)

      mesh.scale.set(0, 0, 0)
      gsap.to(mesh.scale, {
        x: 1, y: 1, z: 1,
        duration: 0.5,
        delay: Math.random() * 0.3,
        ease: 'back.out(1.7)'
      })
    }

    for (const edge of data.edges) {
      const a = nodeMeshes.get(edge.source)
      const b = nodeMeshes.get(edge.target)
      if (a && b) {
        const geometry = new THREE.BufferGeometry().setFromPoints([
          a.position, b.position
        ])
        const material = new THREE.LineBasicMaterial({
          color: 0x2a2a4e,
          transparent: true,
          opacity: 0.4
        })
        scene.add(new THREE.Line(geometry, material))
      }
    }
  }

  function layoutNodes(nodes, edges) {
    const positions = new Map()

    for (const n of nodes) {
      positions.set(n.id, {
        x: (Math.random() - 0.5) * 30,
        y: (Math.random() - 0.5) * 30,
        z: (Math.random() - 0.5) * 30,
        vx: 0, vy: 0, vz: 0
      })
    }

    for (let iter = 0; iter < 80; iter++) {
      const alpha = 1 - iter / 80
      const arr = Array.from(positions.values())

      for (let i = 0; i < arr.length; i++) {
        for (let j = i + 1; j < arr.length; j++) {
          const dx = arr[i].x - arr[j].x
          const dy = arr[i].y - arr[j].y
          const dz = arr[i].z - arr[j].z
          const dist = Math.sqrt(dx * dx + dy * dy + dz * dz) + 0.1
          const f = (4 * alpha) / (dist * dist)
          arr[i].vx += (dx / dist) * f
          arr[i].vy += (dy / dist) * f
          arr[i].vz += (dz / dist) * f
          arr[j].vx -= (dx / dist) * f
          arr[j].vy -= (dy / dist) * f
          arr[j].vz -= (dz / dist) * f
        }
      }

      for (const edge of edges) {
        const a = positions.get(edge.source)
        const b = positions.get(edge.target)
        if (a && b) {
          const dx = b.x - a.x
          const dy = b.y - a.y
          const dz = b.z - a.z
          const dist = Math.sqrt(dx * dx + dy * dy + dz * dz) + 0.1
          const f = dist * 0.04 * alpha
          a.vx += (dx / dist) * f
          a.vy += (dy / dist) * f
          a.vz += (dz / dist) * f
          b.vx -= (dx / dist) * f
          b.vy -= (dy / dist) * f
          b.vz -= (dz / dist) * f
        }
      }

      for (const p of positions.values()) {
        p.x += p.vx * 0.1
        p.y += p.vy * 0.1
        p.z += p.vz * 0.1
        p.vx *= 0.9
        p.vy *= 0.9
        p.vz *= 0.9
      }
    }

    const result = new Map()
    for (const [id, p] of positions) {
      result.set(id, { x: p.x, y: p.y, z: p.z })
    }
    return result
  }
</script>

<div class="graph-container" bind:this={container}></div>

<style>
  .graph-container {
    width: 100%;
    height: 100%;
    position: relative;
  }

  .graph-container :global(canvas) {
    display: block;
  }
</style>
