import { fields, singleton } from "@keystatic/core";

// Export a single `collections` object to register your collection(s)
export const singletons = {
	corpus: singleton({
		label: "Corpus",
		path: "content/corpus",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	annotation: singleton({
		label: "Annotation",
		path: "content/annotation",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	nutzung: singleton({
		label: "Nutzung",
		path: "content/nutzung",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	cite: singleton({
		label: "Zitierung, Kontakt",
		path: "content/cite",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	ueber_uns: singleton({
		label: "Über Uns",
		path: "content/ueber_uns",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
	dank: singleton({
		label: "Dank",
		path: "content/dank",
		schema: {
			title: fields.text({ label: "Title" }),
		},
	}),
};
