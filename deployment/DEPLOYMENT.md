# Déploiement de Token42 (T42)

Ce document décrit comment Token42 et son MultiSigWallet ont été compilés et déployés, et comment reproduire ou vérifier ce déploiement.

## 1. Environnement

| Élément           | Valeur                                 |
| ----------------- | -------------------------------------- |
| Blockchain        | BNB Smart Chain Testnet                |
| Chain ID          | 97                                     |
| Standard du token | BEP-20 (compatible ERC-20)             |
| Langage           | Solidity                               |
| IDE               | Remix IDE (https://remix.ethereum.org) |
| Wallet            | MetaMask (extension Chrome)            |
| Explorer          | https://testnet.bscscan.com            |
| Faucet utilisé    | BNB Chain Faucet (tBNB gratuits)       |

Aucun argent réel n'a été utilisé : tout est déployé sur testnet.

## 2. Compilation (Remix)

| Paramètre              | Token42                         | MultiSigWallet           |
| ---------------------- | ------------------------------- | ------------------------ |
| Version du compilateur | [0.8.34+commit.80d5c536]        | [0.8.34+commit.80d5c536] |
| Optimisation           | [désactivée], [200] runs        | [idem]                   |
| EVM version            | [ex : default / prague]         | [idem]                   |
| Licence                | MIT                             | MIT                      |
| Dépendance             | OpenZeppelin Contracts [v5.4.0] | aucune                   |

## 3. Token42 (BEP-20)

- **Nom** : Token42
- **Ticker** : T42
- **Décimales** : 18
- **Supply initial** : [1 000 000 T42]
- **Valeur passée au constructeur** : `initialSupply = [1000000000000000000000000]` (supply × 10^18)
- **Déployeur** : [0x98F92C5Ca5AD6Aaa550b5717a764867F7eA357D2]
- **Adresse du contrat** : `0x4a46f46b5c3bfbd5b083810b5ab03c2a6d738b7e`
- **Hash de la transaction de déploiement** : [0x98F92C5Ca5AD6Aaa550b5717a764867F7eA357D2]
- **Lien BscScan** : https://testnet.bscscan.com/address/0x4a46f46b5c3bfbd5b083810b5ab03c2a6d738b7e
- **Code source vérifié sur BscScan** : [oui / non]

## 4. MultiSigWallet (bonus)

- **Adresse du contrat** : `0x9C0A2b563ad0E6ab203deFEe9BEA5b30D03c3f57`
- **Hash de la transaction de déploiement** : [0x98F92C5Ca5AD6Aaa550b5717a764867F7eA357D2]
- **Lien BscScan** : https://testnet.bscscan.com/address/0x9C0A2b563ad0E6ab203deFEe9BEA5b30D03c3f57
- **Paramètres du constructeur** :
  - `_owners` = `["0x98F92C5Ca5AD6Aaa550b5717a764867F7eA357D2", "0xD2FD8dCBf5bCaf1b25335E0E08CFF1f8c4bC6154"]`
  - `_required` = [2]
- **Signatures requises** : [2] sur [2]

## 5. Étapes de déploiement

1. Installer MetaMask, créer un wallet et ajouter le réseau BSC Testnet (Chain ID 97).
2. Récupérer des tBNB via le faucet BNB Chain.
3. Dans Remix, créer `Token42.sol` et `MultiSigWallet.sol` (dossier `code/`).
4. Compiler avec les paramètres de la section 2.
5. Dans _Deploy & Run_, choisir **Injected Provider - MetaMask** (réseau BSC Testnet).
6. Déployer `Token42` avec `initialSupply`.
7. Déployer `MultiSigWallet` avec la liste des owners et `_required`.
8. Transférer le supply de Token42 vers le MultiSigWallet (tx : [0x...]).
9. Vérifier et publier le code source sur BscScan.
10. Vérifier les soldes avec `balanceOf`.

## 6. Vérification du déploiement

- Voir le token : https://testnet.bscscan.com/token/0x4a46f46b5c3bfbd5b083810b5ab03c2a6d738b7e
- Appeler `totalSupply()` : doit renvoyer [1000000000000000000000000].
- Appeler `balanceOf(multisig)` : doit renvoyer [1000000000000000000000000].

## 7. Fichiers de ce dossier

- `DEPLOYMENT.md` : ce document
- `Token42.abi.json` : ABI de Token42 (copiée depuis Remix)
- `MultiSigWallet.abi.json` : ABI du multisig
