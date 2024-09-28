<script lang="ts">
	import { currentUser, pb } from './pocketbase';
	import Button from '$lib/components/ui/button/button.svelte';
	import Input from '$lib/components/ui/input/input.svelte';
	import Label from '$lib/components/ui/label/label.svelte';
	import * as Tabs from '$lib/components/ui/tabs/index.js';
	import * as AlertDialog from '$lib/components/ui/alert-dialog';
	import { toast } from 'svelte-sonner';
	import { writable } from 'svelte/store';

	let username: string;
	let password: string;
	let confirmpassword: string;
	let email: string;

	// Control whether the dialog is open or not
	let isDialogOpen = writable(false);

	async function login() {
		try {
			await pb.collection('users').authWithPassword(username, password);
			isDialogOpen.set(false); // Close the dialog on successful login
		} catch (error: any) {
			toast('Invalid username or password'); // Stay open on error
		}
	}

	async function signUp() {
		try {
			const data = {
				email: email,
				username,
				password,
				passwordConfirm: confirmpassword
			};
			const createdUser = await pb.collection('users').create(data);
			await login(); // Attempt login after sign-up
		} catch (error: any) {
			toast('Issue with signing up.'); // Stay open on error
		}
	}

	function signOut() {
		pb.authStore.clear();
	}
</script>

{#if $currentUser}
	<p>
		Signed in as {$currentUser.username}
		<Button on:click={signOut}>Sign Out</Button>
	</p>
{:else}
	<div>
		<AlertDialog.Root bind:open={$isDialogOpen}>
			<AlertDialog.Trigger on:click={() => isDialogOpen.set(true)}>Open</AlertDialog.Trigger>
			<AlertDialog.Content class="w-[80%] sm:!w-[450px]">
				<AlertDialog.Header class="w-[95%] sm:!w-[400px]">
					<AlertDialog.Title>Authentication</AlertDialog.Title>
					<AlertDialog.Description>Login or create a new account.</AlertDialog.Description>
				</AlertDialog.Header>
				<Tabs.Root value="login" class="w-[95%] sm:!w-[400px]">
					<Tabs.List class="grid w-full grid-cols-2">
						<Tabs.Trigger value="login">Log In</Tabs.Trigger>
						<Tabs.Trigger value="signUp">Sign Up</Tabs.Trigger>
					</Tabs.List>
					<Tabs.Content value="login">
						<form on:submit|preventDefault>
							<div class="grid w-full items-center gap-4">
								<div class="flex flex-col space-y-1.5">
									<Label for="Username">Username or Email</Label>
									<Input
										id="username"
										placeholder="Your Username or Email"
										type="text"
										bind:value={username}
									/>
								</div>
								<div class="flex flex-col space-y-1.5">
									<Label for="Password">Password</Label>
									<Input
										id="password"
										placeholder="Your Password"
										type="password"
										bind:value={password}
									/>
								</div>
							</div>
						</form>
						<!-- Custom button to handle login -->
						<Button class="mt-3" on:click={login}>Login</Button>
						<AlertDialog.Cancel on:click={() => isDialogOpen.set(false)}>Cancel</AlertDialog.Cancel>
					</Tabs.Content>
					<Tabs.Content value="signUp">
						<form on:submit|preventDefault>
							<div class="grid w-full items-center gap-4">
								<div class="flex flex-col space-y-1.5">
									<Label for="Email">Email</Label>
									<Input id="email" placeholder="Your Email" type="email" bind:value={email} />
								</div>
								<div class="flex flex-col space-y-1.5">
									<Label for="Username">Username</Label>
									<Input
										id="username"
										placeholder="Your Username"
										type="text"
										bind:value={username}
									/>
								</div>
								<div class="flex flex-col space-y-1.5">
									<Label for="Password">Password</Label>
									<Input
										id="password"
										placeholder="Your Password"
										type="password"
										bind:value={password}
									/>
								</div>
								<div class="flex flex-col space-y-1.5">
									<Label for="ConfirmPassword">Confirm Password</Label>
									<Input
										id="confirmpassword"
										placeholder="Confirm Your Password"
										type="password"
										bind:value={confirmpassword}
									/>
								</div>
							</div>
						</form>
						<!-- Custom button to handle sign-up -->
						<Button class="mt-3" on:click={signUp}>Sign Up</Button>
						<AlertDialog.Cancel on:click={() => isDialogOpen.set(false)}>Cancel</AlertDialog.Cancel>
					</Tabs.Content>
				</Tabs.Root>
			</AlertDialog.Content>
		</AlertDialog.Root>
	</div>
{/if}
