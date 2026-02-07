// Configuration des Collections Astro pour le Labo
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

export const collections = {
  'labo': laboCollection,
};
