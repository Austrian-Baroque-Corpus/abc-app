import { component, defineMarkdocConfig, nodes } from "@astrojs/markdoc/config";

export default defineMarkdocConfig({
	nodes: {
		image: {
			...nodes.image,
			render: component("./src/components/MarkdocImage.astro"),
		},
		document: {
			...nodes.document,
			render: component("./src/components/MarkdocDocument.astro"),
		},
		paragraph: {
			...nodes.paragraph,
			render: component("./src/components/MarkdocParagraph.astro"),
			children: ["text"],
		},
	},
	tags: {
		"text-image": {
			render: component("./src/components/MarkdocTextImage.astro"),
			attributes: {
				image: { type: String },
				textContainer: { type: String },
				image_alt: { type: String },
			},
		},
	},
});
