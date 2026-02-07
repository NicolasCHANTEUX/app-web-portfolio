// Configuration des Collections Astro pour le Labo et la Timeline
import { defineCollection, z } from 'astro:content';

const laboCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    type: z.enum(['script', 'config', 'snippet', 'tool']),
    tags: z.array(z.string()),
    language: z.string().optional(), // bash, nginx, docker, etc.
    dateAdded: z.date().optional(),
    difficulty: z.enum(['beginner', 'intermediate', 'advanced']).optional(),
  }),
});

const timelineCollection = defineCollection({
  type: 'content',
  schema: z.object({
    year: z.string(),
    title: z.string(),
    description: z.string(),
    icon: z.string(), // terminal, code, container, leaf, rocket
    category: z.enum(['milestone', 'project', 'devops', 'philosophy', 'career']),
    lesson: z.string(), // La leçon apprise
    link: z.string().optional(), // Lien interne vers autre page
    linkText: z.string().optional(), // Texte du lien
  }),
});

export const collections = {
  'labo': laboCollection,
  'timeline': timelineCollection,
};
