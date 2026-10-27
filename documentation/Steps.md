#  1.Préparer l'environnement

## 1.1 Installer MetaMask et ajouter le testnet BSC

Installe l'extension MetaMask dans ton navigateur, puis ajoute le réseau de test BNB Smart Chain manuellement :

| **Paramètre** | **Valeur**                                        | **Explication**                                                                                                           |
| :------------ | :------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------ |
| Nom du réseau | BNB Smart Chain Testnet                           | Le nom que tu verras dans MetaMask. Tu peux le considérer comme une étiquette.                                            |
| URL RPC       | `https://data-seed-prebsc-1-s1.bnbchain.org:8545` | L'adresse du serveur qui permet à MetaMask de communiquer avec la blockchain.                                             |
| Chain ID      | `97`                                              | L'identifiant numérique du réseau. Il permet notamment aux applications et aux transactions de cibler le bon réseau.      |
| Symbole       | `tBNB`                                            | Le symbole de la monnaie utilisée sur ce réseau de test. Elle sert notamment à payer les frais de transaction (gas fees). |
| Explorateur   | `https://testnet.bscscan.com`                     | Le site qui permet de consulter les transactions, les adresses et les contrats intelligents du réseau.                    |

Ces informations sont confirmées par la documentation officielle . Le Chain ID 97 est essentiel : si tu te trompes, les transactions échoueront.

## 1.2 Obtenir des tBNB gratuits

Va sur le faucet officiel de BNB Chain (https://www.bnbchain.org/en/testnet-faucet) et demande des tBNB. Tu en as besoin pour payer les frais de gas lors du déploiement . Tu peux généralement en obtenir toutes les 24 heures.

Ou bien sur leur bot telegrame @bnbchain_officiel_bot

# 2.Écrire le smart contract

## 2.1 Ouvrir Remix IDE
Va sur https://remix.ethereum.org. Remix est un IDE en ligne qui te permet d'écrire, compiler et déployer des contrats Solidity sans installation locale.
Crée un nouveau fichier dans le dossier contracts et nomme-le Token42.sol.

## 2.2 Le code du token
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token42 is ERC20 {
    constructor(uint256 initialSupply) ERC20("Token42", "T42") {
        _mint(msg.sender, initialSupply);
    }
}
```
Ce code est écrit en Solidity, un langage de programmation utilisé pour développer des smart contracts sur des blockchains compatibles avec Ethereum, comme BNB Smart Chain.

# 3.Compiler et déployer

## 3.1 Compiler
Dans Remix, va dans l'onglet Solidity Compiler, sélectionne la version 0.8.0 ou supérieure, et clique sur Compile Token42.sol. Vérifie qu'il n'y a pas d'erreur.

## 3.2 Déployer
Va dans l'onglet Deploy & Run Transactions :

- Dans Environment, sélectionne Injected Provider MetaMask.
- MetaMask te demandera de te connecter.
- Vérifie que MetaMask est bien sur BNB Smart Chain Testnet (Chain ID 97).
- Dans le champ à côté de Deploy, entre le supply initial en wei (par exemple 1000000000000000000000000 pour 1 million de tokens).
- Clique sur Deploy et confirme la transaction dans MetaMask.
- Une fois la transaction confirmée, ton contrat apparaît dans la section Deployed Contracts. Copie son adresse.

# 4.Vérifier le contrat sur BscScan Testnet

La vérification est obligatoire selon le sujet : "publie-le sur un blockchain explorer". Elle permet à n'importe qui de lire ton code source et de vérifier qu'il correspond au bytecode déployé .

## **Procédure :**
- Va sur https://testnet.bscscan.com et cherche l'adresse de ton contrat.
- Onglet Contract → Verify and Publish.
- Sélectionne :
    1. Compiler Type : Solidity (Single file)
    1. Compiler Version : la même que dans Remix (ex: v0.8.0)
    1. License : MIT
- Colle le code source complet de ton contrat.
- Si le contrat importe OpenZeppelin, tu devras utiliser la vérification Standard- Json-Input ou aplatir le code (flatten) avec un outil comme Hardhat. Une alternative simple : copie l'intégralité du code ERC20 d'OpenZeppelin dans un seul fichier avant de déployer.
- Une fois vérifié, un checkmark vert apparaît sur la page du contrat.

# 5.Multisig

## Étape 1 : Créer le fichier dans Remix
1. Dans Remix, à gauche dans l'explorateur de fichiers, clique sur l'icône "Nouveau fichier".
1. Nomme-le MultiSigWallet.sol.
1. Copier coller le code du fichiers code/MultiSigWallet.sol

## Étape 2 : Préparer tes 2 comptes dans MetaMask
Pour tester, tu as besoin de 2 adresses différentes :

1. Compte 1 : Ton compte principal (celui qui a déployé le Token42).
1. Compte 2 : Un deuxième compte. Dans MetaMask, clique sur l'icône de profil en haut à droite → "Ajouter un compte". Note bien l'adresse de ce compte 2.

**Note** : Les deux comptes doivent avoir un peu de tBNB pour payer le gaz des transactions. Si le compte 2 n'en a pas, envoie-lui 0.05 tBNB depuis le compte 1.

## Étape 3 : Déployer le contrat MultiSig
1. Dans Remix, onglet "Solidity Compiler", compile le fichier MultiSigWallet.sol.
1. Va dans l'onglet "Deploy & Run Transactions".
1. Dans le menu déroulant "Contract", sélectionne MultiSigWallet.
1. Tu vois un champ à côté du bouton "Deploy" (le champ du constructeur). Tu dois y entrer un tableau d'adresses et un nombre.
    - Format : ["adresse_compte_1", "adresse_compte_2"], 2
    - Exemple : ["0x1234...", "0xABCD..."], 2
1. Clique sur "Deploy" et valide avec le Compte 1.

## Étape 4 : Transférer des Tokens vers le Multisig
Le multisig est vide, il faut lui donner des Token42.
1. Dans Remix, connecte-toi avec le Compte 1.
1. Dans "Deploy & Run", sélectionne ton contrat Token42 (déployé précédemment).
1. Dans les fonctions, trouve transfer.
1. Remplis :
    - to : L'adresse de ton contrat MultiSigWallet (copie-la depuis Remix).
    - value : Par exemple 1000000000000000000 (pour 1 token, car il y a 18 décimales).
1. Clique sur "transact". Les tokens sont maintenant dans le multisig.