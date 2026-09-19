# Beastbound TCG — Rules

A 2-player collectible card game. This document defines the rules engine; see [game-cards.md](game-cards.md) for the full stat line of every card in the base set.

## 1. Card supertypes

Every card is one of four supertypes:

- **Beast** — a monster you battle with. Has a Stage (1, 2, or 3), an HP total, a Type, up to 2 attacks, a Weakness, a Resistance, and a Retreat Cost.
- **Supporter** — a named character card with a one-time effect. Playing one uses your turn's single Supporter play (see §5).
- **Item** — an equipment or consumable card with a one-time or persistent effect. Unlike Supporters, you may play any number of Items per turn.
- **Energy** — a Energy card provides 1 Energy of its printed type when attached to a Beast. There is one Energy per type (Electric, Fighting, Fire, Psychic, Water, Nature).

## 2. The 6 types & the type chart

Beastbound has six energy types: **Fire, Nature, Water, Electric, Psychic, Fighting**.

Every type has exactly one Weakness (the type it takes double damage from) and one Resistance (the type it takes reduced damage from), so both boxes on the card template are always filled.

**Weakness cycle** — each type is beaten by the type before it in this loop:

```
Fighting → Fire → Nature → Water → Electric → Psychic → (back to Fighting)
```

**Resistance pairs** — three reciprocal pairs, unrelated to the weakness cycle:

```
Fire ↔ Electric        Nature ↔ Psychic        Water ↔ Fighting
```

| Type | Weak to (×2 dmg) | Resists (−20 dmg) |
|---|---|---|
| Fire | Fighting | Electric |
| Nature | Fire | Psychic |
| Water | Nature | Fighting |
| Electric | Water | Fire |
| Psychic | Electric | Nature |
| Fighting | Psychic | Water |

**Damage calculation**, applied in order:
1. Start with the attack's printed damage.
2. If the attacker's type is the defender's Weakness, **double** the damage.
3. If the attacker's type is the defender's Resistance, **subtract 20** (minimum 0).

Attack costs are paid only in the attacking Beast's own type — there is no colorless/generic energy in this set.

## 3. Deck construction

- A deck has exactly **60 cards**.
- No more than **4 copies** of any single named card, except Energy (unlimited copies).
- A legal deck must contain at least one Stage-1 Beast (you need one to start the game).

## 4. Setup

1. Shuffle your deck and draw a 7-card opening hand. If you have no Stage-1 Beast in hand, you may mulligan (reshuffle and redraw 7; your opponent may draw 1 extra card).
2. Choose 1 Stage-1 Beast from your hand and place it face-down as your **Active Beast**; place any number of additional Stage-1 Beasts face-down on your **Bench** (max 5 Benched Beasts at a time).
3. Set the top **6 cards** of your deck aside, face-down, as your **Prize cards**.
4. Both players reveal their Active Beast and Bench simultaneously, then begin.

## 5. Turn structure

Each turn, in order:

1. **Draw** — draw 1 card from your deck. (The player going first skips their draw on turn 1.)
2. **Action phase** — in any order, any number of times unless noted:
   - Attach **1 Energy card** from your hand to 1 of your Beasts (once per turn).
   - Play any number of **Item** cards.
   - Play **1 Supporter** card (once per turn — the 3 named characters, Jack/Jane/Shane, are Supporters).
   - **Evolve** a Beast by placing the next-stage card from your hand on top of it (a Beast can't evolve the turn it was played, and can't evolve more than once per turn).
   - **Retreat**: once per turn, discard Energy from your Active Beast equal to its Retreat Cost to swap it with a Benched Beast.
3. **Attack** — declare 1 attack your Active Beast has enough Energy attached to pay for, resolve its effect and damage, then your turn ends. Attacking is optional; you may end your turn without attacking.
4. **Between turns** — resolve Poison and Burn damage, then check Paralysis/Sleep/Confusion recovery, for whichever Beast is affected (see §6).

If a Beast's damage counters equal or exceed its HP, it is **Knocked Out**: remove it (and anything attached to it) from play, its controller's opponent takes 1 Prize card into their hand, and the controller must move a Benched Beast into the Active position before continuing (if none is available, they lose — see §7).

## 6. Status effects (Special Conditions)

A Beast can only have one of these at a time (a new one replaces the old one), except Poison and Burn which can stack with a non-damage condition.

| Condition | Effect |
|---|---|
| **Paralyzed** | Can't attack or retreat during its controller's next turn. Then recovers automatically. |
| **Confused** | Before attacking, flip a coin. Tails: the attack does nothing and this Beast takes 20 damage instead. |
| **Poisoned** | Between turns, take 10 damage. Lasts until cured. |
| **Burned** | Between turns, take 20 damage, then flip a coin — heads cures the Burn. |
| **Asleep** | Can't attack or retreat. At the start of its controller's turn, flip a coin — heads wakes it up. |

## 7. Win conditions

You win immediately if any of the following happens to your opponent:

- They have taken all **6 of their Prize cards**.
- They have **no Beasts in play** and no way to add one at the start of their turn.
- They are required to **draw a card but their deck is empty**.

## 8. Card anatomy

Every Beast card prints, top to bottom:

- **Name**, **HP**, and the **Type icon** in the header.
- The supertype/evolution banner (for beasts "Basic", "Stage 1", or "Stage 2" evolution label), for items "Item", for supporters "Supporter", and for energy cards "Energy".
- The **illustration**.
- An **info box** listing its attacks — this design standardizes on **exactly 2 attacks per Beast** (the physical layout has room for a 3rd; that slot is reserved for future promo/special cards, not used in the base set). Each attack shows its Energy cost as colored pips, its name, up to 2 lines of rules text, and its damage number.
- A footer row with **Weakness**, **Resistance**, and **Retreat Cost** (each as a type icon, or a number of pips for Retreat).
- A card number (`NNN/064`) and artist credit.

## 9. Design baseline (for consistency, and for any future expansion)

| Stage | HP range | Attack 1 (cheap/utility) | Attack 2 (signature) | Retreat Cost |
|---|---|---|---|---|
| Stage 1 (Basic) | 55–70 | 1 Energy, 10–20 dmg, often a coin-flip status effect | 1–2 Energy, 20–30 dmg | 0–1 |
| Stage 2 (mid-evolution) | 95–120 | 1 Energy, 20–30 dmg | 2 Energy, 50 dmg, often a coin-flip effect or minor conditional | 1–2 |
| Stage 3 / final evolution | 140–180 | 2 Energy, 40–60 dmg, often a coin-flip status effect | 3 Energy, 90–130 dmg, usually a conditional bonus or self-drawback | 2–3 |

Retreat Cost gets a ±1 flavor adjustment for especially bulky lines (rock/turtle/kraken-themed: +1) or especially light ones (psychic/ghost/bug-themed: −1, floor 0).

## 10. Rarity & the booster pack

The existing booster (`ce_expansion_beastbound_first_booster.lua`) defines an 11-card pack: 4 Common slots, 1 Common-Supporter slot, 3 Uncommon slots, 1 Rare slot, and 2 Common-Energy slots. Rarity in this set is assigned so every slot always has legal cards to draw, without any code changes:

| Rarity | Cards |
|---|---|
| **Common** | All 17 Stage-1 Beasts, all 3 Supporters, 2 Items (Minor Potion, Noxious Draught) |
| **Uncommon** | All 14 Stage-2 (mid-evolution) Beasts, 3 Items (Tactic Scroll, Boots of Flight, Lion Gauntlets) |
| **Rare** | All 17 final-evolution Beasts, 2 Items (Runic Sword, Tome of Fate) |
| **Energy** (own slot type, always Common) | All 6 Energy |
