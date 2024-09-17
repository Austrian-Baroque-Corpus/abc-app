// import markdoc from "@astrojs/markdoc";
import mdx from "@astrojs/mdx";
import react from "@astrojs/react";
import tailwind from "@astrojs/tailwind";
// import keystatic from "@keystatic/astro";
import { defineConfig } from "astro/config";
import icon from "astro-icon";

// https://astro.build/config
export default defineConfig({
	integrations: [
		icon({
			include: {
				lucide: ["*"],
			},
			svgoOptions: {
				multipass: true,
				plugins: [
					{
						name: "preset-default",
						params: {
							overrides: {
								removeViewBox: false,
							},
						},
					},
				],
			},
		}),
		react(),
		// keystatic(),
		tailwind(),
		mdx(),
	],
	build: {
		format: "file",
	},
	output: "static",
	server: {
		port: 3030,
	},
	site: "https://austrian-baroque-corpus.github.io/abc-app",
	base: "/",
});
