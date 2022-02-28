<script>
	import Router from "svelte-spa-router";
	import { wrap } from "svelte-spa-router/wrap";
	import Navigation from "./components/Navigation.svelte";
	import Footer from "./components/Footer.svelte";
	import Login from "./pages/Login.svelte";
	import Home from "./pages/home/Home.svelte";
	import Company from "./pages/company/Company.svelte";
	import Admin from "./pages/admin/Admin.svelte";
	import Setting from "./pages/setting/Setting.svelte";
	import NotFound from "./pages/NotFound.svelte";
	export let table_header_font;
	export let table_body_font;
	let token = localStorage.getItem("token");
	let routes = "";
	let isNav = false;
	if (token == "" || token == null) {
		routes = {
			"/": wrap({
				component: Login,
			}),
			"*": NotFound,
		};
	} else {
		isNav = true;
		routes = {
			"/": wrap({
				component: Home,
			}),
			"/company": wrap({
				component: Company,
			}),
			"/admin": wrap({
				component: Admin,
				props: {
					table_header_font: table_header_font,
					table_body_font: table_body_font,
				},
			}),
			"/setting": wrap({
				component: Setting,
			}),
			"*": NotFound,
		};
	}
</script>

{#if isNav}
	<Navigation />
{/if}
<Router {routes} />
<Footer />
