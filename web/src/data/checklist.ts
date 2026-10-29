import * as jsyaml from 'js-yaml';

import type { Sections } from '~/types/PSC';
// Version française ; l'original anglais reste dans personal-security-checklist.yml.
import checklistYaml from '../../../personal-security-checklist.fr.yml?raw';

const checklists = jsyaml.load(checklistYaml) as Sections;

export default checklists;
