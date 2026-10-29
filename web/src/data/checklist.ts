import * as jsyaml from 'js-yaml';

import type { Sections } from '~/types/PSC';
// Version française ; l'original anglais reste dans personal-security-checklist.yml.
// Vite exige un chemin d'import littéral : le garder aligné sur CHECKLIST_FILE.
import checklistYaml from '../../../personal-security-checklist.fr.yml?raw';

/** Fichier de la checklist, servi à la racine du site (web/public et vite.config.mts). */
export const CHECKLIST_FILE = 'personal-security-checklist.fr.yml';

const checklists = jsyaml.load(checklistYaml) as Sections;

export default checklists;
