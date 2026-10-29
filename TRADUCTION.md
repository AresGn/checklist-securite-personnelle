# Traduction française

Ce fork traduit la [Personal Security Checklist](https://github.com/Lissy93/personal-security-checklist)
en français, puis l'adapte au contexte de l'Afrique francophone.

## Version d'origine traduite

| Élément | Valeur |
| --- | --- |
| Dépôt d'origine | `Lissy93/personal-security-checklist`, branche `master` |
| Commit de référence | `a89c3b4` (15 octobre 2026) |
| Fichier source | `personal-security-checklist.yml` |
| Fichier traduit | `personal-security-checklist.fr.yml` |

Quand l'original évolue, comparer ses changements depuis le commit de référence, les reporter dans
`personal-security-checklist.fr.yml`, puis mettre à jour le commit de référence ci-dessus :

```bash
git remote add upstream https://github.com/Lissy93/personal-security-checklist.git   # une fois
git fetch upstream
git diff a89c3b4 upstream/master -- personal-security-checklist.yml
```

## Avancement

| # | Section d'origine | Titre français | État |
| --- | --- | --- | --- |
| 1 | Authentication | Authentification | ⏳ À traduire |
| 2 | Web Browsing | Navigation web | ⏳ À traduire |
| 3 | Email | E-mail | ⏳ À traduire |
| 4 | Messaging | Messagerie | ⏳ À traduire |
| 5 | Social Media | Réseaux sociaux | ⏳ À traduire |
| 6 | Networks | Réseaux | ⏳ À traduire |
| 7 | Mobile Devices | Appareils mobiles | ⏳ À traduire |
| 8 | Personal Computers | Ordinateurs personnels | ⏳ À traduire |
| 9 | Smart Home | Maison connectée | ⏳ À traduire |
| 10 | Personal Finance | Finances personnelles | ⏳ À traduire |
| 11 | Human Aspect | Facteur humain | ⏳ À traduire |
| 12 | Physical Security | Sécurité physique | ⏳ À traduire |
| — | *(ajout)* | Afrique francophone | ⏳ À rédiger |

Ordre prévu : Authentification, Messagerie, Appareils mobiles, puis les autres sections.

## Règles de traduction

- **Ne traduire que les valeurs** `title`, `description`, `intro`, `point` et `details`.
- **Ne jamais modifier les clés techniques** : `slug`, `icon`, `color`, `priority` (`Essential`,
  `Optional`, `Advanced`) restent en anglais, car le site et le schéma s'en servent.
- **Garder tous les liens**. Si une version française officielle de la ressource existe, la mettre à la place.
- **Vouvoyer le lecteur**, phrases courtes, vocabulaire courant ; un terme technique s'explique à sa
  première apparition.
- **Valider après chaque section** : `make validate`.
- **Une section par PR**, pour garder des relectures courtes.

## Glossaire

| Anglais | Français |
| --- | --- |
| password manager | gestionnaire de mots de passe |
| passphrase | phrase de passe |
| 2-factor authentication (2FA) | authentification à deux facteurs (2FA) |
| credential stuffing | bourrage d'identifiants |
| brute force | force brute |
| data breach | fuite de données |
| phishing | hameçonnage |
| tracker | traqueur |
| fingerprinting | empreinte numérique du navigateur |
| end-to-end encryption | chiffrement de bout en bout |
| VPN | VPN (réseau privé virtuel) |
| malware | logiciel malveillant |
| ransomware | rançongiciel |
| firmware | micrologiciel |
| SIM swap | vol de carte SIM (SIM swap) |
| social engineering | ingénierie sociale |
| alias (email) | adresse e-mail alias |
| security key | clé de sécurité |
| Essential / Optional / Advanced | Essentiel / Facultatif / Avancé (affichage uniquement) |

Ajouter ici tout nouveau terme dès sa première traduction, pour garder le vocabulaire cohérent.

## Section Afrique francophone

Conseils ajoutés par ce fork, absents de l'original. Chaque conseil s'appuie sur une source fiable
(régulateur, opérateur, CERT national, autorité de protection des données).

- Mobile Money : code secret, faux SMS de crédit, que faire après une fraude.
- Vol de carte SIM (SIM swap) : verrouiller sa ligne, éviter les codes par SMS pour les comptes importants.
- WhatsApp : vérification en deux étapes, code à 6 chiffres, arnaque du « proche en difficulté ».
- Téléphones d'entrée de gamme : sources d'applications, permissions, appareil sans mises à jour.
- Données personnelles : droits des personnes et plainte auprès de l'autorité de protection des données
  (APDP au Bénin).

## Reste à faire côté site

- Traduire l'interface (`web/src`) : en-tête, boutons, pages, puis passer `lang="en"` à `lang="fr"` dans
  `web/src/root.tsx`.
- Générer `CHECKLIST.fr.md` à partir du fichier français.
- Adapter les liens de la page « À propos » au fork.
- La génération statique échoue déjà sur la page `/about/` dans le projet d'origine
  (`yarn build.ssg`) : à corriger avant le premier déploiement.
