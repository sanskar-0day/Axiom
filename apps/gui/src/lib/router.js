import { writable } from 'svelte/store';

export const currentRoute = writable('packages');

export function navigate(route) {
    currentRoute.set(route);
    console.log('Navigated to:', route);
}
