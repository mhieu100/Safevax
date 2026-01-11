# UI Improvement Plan - Client Profile Page

## Objective
Revamp the Client Profile Page to resemble a professional "Patient Portal" or "Medical Dashboard". The goal is to reduce clutter (too many tabs), improve navigation, and apply the premium medical aesthetic.

## Key Changes

### 1. Layout Restructuring
- **Current**: Top Info Card + Left Sidebar (Stats) + Right Content (Tabs).
- **New**: **Dashboard Layout**.
    - **Left Sidebar**: Persistent Navigation Menu (Vertical Tabs).
    - **Main Content Area**: Dynamic content based on selection.
    - **Top Header**: "Patient ID" summary card (smaller, sticky or at top).

### 2. Tab Consolidation
The current 7 tabs are too granular. We will consolidate them into 5 core sections:
1.  **Dashboard (Overview)**: *New!* A summary view showing next appointment, recent vaccines, and health stats.
2.  **My Records**: Combines *Vaccination History*, *Vaccine Records*, and *Vaccine Passport*.
3.  **Appointments**: Manages *Upcoming* and *Past* appointments.
4.  **Family Members**: Manages family profiles.
5.  **Settings**: Combines *Health Profile* editing and *Account Settings*.

### 3. Component Upgrades

#### A. ProfileSidebar (Navigation)
- **Style**: Vertical menu with premium icons.
- **Active State**: High contrast background (e.g., Blue-50 with Blue-600 text).
- **Items**: Dashboard, My Records, Appointments, Family, Settings.

#### B. Patient ID Card (Header)
- **Style**: A sleek, horizontal card showing Avatar, Name, ID Number, and a QR Code (for quick check-in).
- **Background**: Glassmorphism or a subtle medical cross pattern.

#### C. Dashboard View (New)
- **Widgets**:
    - **Next Appointment**: Countdown and details.
    - **Vaccination Status**: "Fully Vaccinated" or "Dose 2 Due".
    - **Recent Activity**: List of recent actions.

#### D. My Records View
- **Tabs inside**: History, Digital Passport.
- **Visuals**: Timeline view for history, Flip card for Passport.

## Implementation Steps

1.  **Update `ProfileSidebar.jsx`**: Convert to a vertical navigation menu.
2.  **Create `DashboardTab.jsx`**: Implement the new overview widgets.
3.  **Refactor `ProfileTabs.jsx`**: Update the mapping to the new 5 sections.
4.  **Update `index.jsx`**: Adjust the grid layout to accommodate the new sidebar-heavy design.
5.  **Style Updates**: Apply `bg-slate-50`, rounded corners, and shadow effects.

## Design Tokens
- **Colors**: Slate-900 (Text), Blue-600 (Primary), Emerald-500 (Success/Verified).
- **Shapes**: `rounded-3xl` for main containers, `rounded-2xl` for widgets.
- **Shadows**: Soft, diffused shadows (`shadow-lg shadow-blue-900/5`).
