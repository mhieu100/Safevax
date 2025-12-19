import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import {
  addToCart,
  clearBackendCart,
  getMyCart,
  removeCartItem,
  updateCartItem,
} from '@/services/cart.service';

const useCartStore = create(
  persist(
    (set, get) => ({
      items: [],
      loading: false,

      // Initial fetch from backend
      fetchCart: async () => {
        const token = localStorage.getItem('token');
        if (!token) return; // Guest: stay with local storage

        try {
          set({ loading: true });
          const response = await getMyCart();
          if (response && Array.isArray(response)) {
            // Map backend response to local structure
            const mappedItems = response.map((item) => ({
              id: item.id, // CartItem ID
              vaccine: {
                id: item.vaccineId,
                name: item.vaccineName,
                image: item.vaccineImage,
                price: item.price,
              },
              quantity: item.quantity,
            }));
            set({ items: mappedItems });
          }
        } catch (error) {
          console.error('Failed to fetch cart:', error);
        } finally {
          set({ loading: false });
        }
      },

      addItem: async (vaccine, quantity = 1) => {
        const token = localStorage.getItem('token');
        const items = get().items;
        const exist = items.find((i) => i.vaccine.id === vaccine.id);

        // Optimistic UI update
        if (exist) {
          set({
            items: items.map((i) =>
              i.vaccine.id === vaccine.id ? { ...i, quantity: i.quantity + quantity } : i
            ),
          });
        } else {
          set({ items: [...items, { vaccine, quantity }] });
        }

        // Sync to backend if logged in
        if (token) {
          try {
            await addToCart({ vaccineId: vaccine.id, quantity });
            // Ideally refetch to get real IDs, but for speed we might skip or rely on next refresh
            // Calling get().fetchCart() here is safest to ensure consistency
            get().fetchCart();
          } catch (error) {
            console.error('Sync to backend failed', error);
            // Rollback or notify could happen here
          }
        }
      },

      addToCart: (product) => {
        get().addItem(product, 1);
      },

      removeItem: async (vaccineId) => {
        const items = get().items;
        const target = items.find((i) => i.vaccine.id === vaccineId);
        if (!target) return;

        // Optimistic UI
        set({
          items: items.filter((i) => i.vaccine.id !== vaccineId),
        });

        // Sync backend
        const token = localStorage.getItem('token');
        if (token && target.id) {
          // We need CartItem ID (target.id) not Vaccine ID
          try {
            await removeCartItem(target.id);
          } catch (_e) {
            console.error(_e);
          }
        }
      },

      removeFromCart: (vaccineId) => {
        get().removeItem(vaccineId);
      },

      increase: async (vaccineId) => {
        const items = get().items;
        const target = items.find((i) => i.vaccine.id === vaccineId);
        if (!target) return;

        const newQty = target.quantity + 1;

        // Optimistic
        set({
          items: items.map((i) => (i.vaccine.id === vaccineId ? { ...i, quantity: newQty } : i)),
        });

        // Sync
        const token = localStorage.getItem('token');
        if (token && target.id) {
          try {
            await updateCartItem(target.id, newQty);
          } catch (_e) {}
        }
      },

      decrease: async (vaccineId) => {
        const items = get().items;
        const target = items.find((i) => i.vaccine.id === vaccineId);
        if (!target) return;

        if (target.quantity === 1) {
          get().removeItem(vaccineId);
        } else {
          const newQty = target.quantity - 1;
          set({
            items: items.map((i) => (i.vaccine.id === vaccineId ? { ...i, quantity: newQty } : i)),
          });
          const token = localStorage.getItem('token');
          if (token && target.id) {
            try {
              await updateCartItem(target.id, newQty);
            } catch (_e) {}
          }
        }
      },

      updateQuantity: async (vaccineId, quantity) => {
        if (quantity <= 0) {
          get().removeItem(vaccineId);
          return;
        }

        const items = get().items;
        const target = items.find((i) => i.vaccine.id === vaccineId);

        // Optimistic
        set({
          items: items.map((i) => (i.vaccine.id === vaccineId ? { ...i, quantity } : i)),
        });

        // Sync
        const token = localStorage.getItem('token');
        if (token && target?.id) {
          try {
            await updateCartItem(target.id, quantity);
          } catch (_e) {}
        }
      },

      clearCart: async () => {
        set({ items: [] });
        const token = localStorage.getItem('token');
        if (token) {
          try {
            await clearBackendCart();
          } catch (_e) {}
        }
      },

      syncLocalToBackend: async () => {
        // Logic to push local items to backend upon login
        // For now, simpler implementation: just fetch backend
        get().fetchCart();
      },

      totalQuantity: () => get().items.reduce((acc, item) => acc + item.quantity, 0),

      totalPrice: () =>
        get().items.reduce((acc, item) => acc + item.vaccine.price * item.quantity, 0),

      get itemCount() {
        return get().totalQuantity();
      },
      get total() {
        return get().totalPrice();
      },
    }),
    {
      name: 'cart-storage',
      partialize: (state) => ({ items: state.items }), // Only persist items to localStorage
    }
  )
);

export { useCartStore };
export default useCartStore;
