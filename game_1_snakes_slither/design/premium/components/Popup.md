# Popup

The modal card for every in-game moment: Pause, Second Chance, Level Complete, Level Failed, Gift Basket, mini shop.

- Width 328 (phone), `canopy`, radius `radius-lg`, padding `space-24`, shadow `elev-2`, over the `scrim`.
- Optional badge on the top edge (`emerald` pill): the level number.
- Title `h1`; content centred; buttons full width, the primary action last-but-one and a ghost dismissal last.
- Enters with `popupIn` (300 ms, ease-out-back, from 92% scale); plays the `popupOpen` UI sound. Reduced motion: fade only.
- Stars animate in one by one (120 ms apart, a small pop each); empty stars stay as dim placeholders.
