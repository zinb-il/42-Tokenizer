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