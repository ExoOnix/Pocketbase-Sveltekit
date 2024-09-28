<script>
	import Login from '../lib/pocketbase/Login.svelte';
	import Sun from 'svelte-radix/Sun.svelte';
	import Moon from 'svelte-radix/Moon.svelte';
	import Navbar from '$lib/components/navbar/navbar.svelte';
	import { resetMode, setMode } from 'mode-watcher';
	import { Button } from '$lib/components/ui/button/index';
	import * as DropdownMenu from '$lib/components/ui/dropdown-menu/index';
</script>
<Navbar />
<Login />
