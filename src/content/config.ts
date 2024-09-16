import { fields, singleton } from "@keystatic/core";

// Export a single `collections` object to register your collection(s)
export const singletons = {
	corpus: singleton({
		label: "Corpus",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	annotation: singleton({
		label: "Annotation",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	nutzung: singleton({
		label: "Nutzung",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	cite: singleton({
		label: "Zitierung, Kontakt",
		path: "cite",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	ueber_uns: singleton({
		label: "Über Uns",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	dank: singleton({
		label: "Dank",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
};
