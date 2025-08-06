# Tool Visibility & Management Feature

## Overview
This feature allows users to customize which tools are visible and their order in the application through a "Tools & Shortcuts" section in the Settings screen.

## Components Implemented

### 1. Tool Visibility Service (`lib/services/tool_visibility_service.dart`)
- Manages tool visibility and order using SharedPreferences
- Provides default tool configuration (Text Template Generator and Random Tools)
- Methods to save/load tool visibility state and reset to defaults
- `ToolConfig` model class with tool metadata (id, name, description, icon, colors)

### 2. Tool Visibility Dialog (`lib/widgets/tool_visibility_dialog.dart`)
- Interactive dialog for managing tool visibility and order
- Drag-and-drop reordering functionality using ReorderableListView
- Toggle switches for show/hide functionality
- Warning message when no tools are visible
- Reset to default option
- Modern Material 3 design with proper theming and localization

### 3. Main Settings Integration (`lib/screens/main_settings.dart`)
- Added new "Tools & Shortcuts" section to settings
- "Display and arrange tools" option that opens the management dialog
- Callback mechanism to refresh tool visibility when changes are made
- Proper localization support

### 4. Dynamic Tool Selection (`lib/main.dart`)
- Converted `ToolSelectionScreen` from StatelessWidget to StatefulWidget
- Dynamic loading of visible tools from the service
- Fallback UI when all tools are hidden
- Refresh mechanism when tool visibility changes
- Integration with both desktop and mobile layouts

### 5. Localization Support
Added localization strings in both English and Vietnamese:
- `toolsShortcuts`: "Tools & Shortcuts"
- `displayArrangeTools`: "Display and arrange tools" 
- `displayArrangeToolsDesc`: "Manage which tools are visible and their order"
- `manageToolVisibility`: "Manage Tool Visibility"
- `dragToReorder`: "Drag to reorder tools"
- `allToolsHidden`: "All tools are hidden"
- `allToolsHiddenDesc`: "Go to settings to make tools visible"
- `resetToDefault`: "Reset to default"
- `resetSuccess`: "Reset successful"

## User Workflow

### Desktop Layout
1. User opens the application in desktop mode (screen width ≥ 600px)
2. Tools are displayed in the left sidebar based on visibility settings
3. User clicks Settings in the sidebar
4. User navigates to "Tools & Shortcuts" → "Display and arrange tools"
5. Dialog opens allowing drag-and-drop reordering and toggle visibility
6. Changes are saved automatically
7. Sidebar refreshes immediately with new tool visibility/order

### Mobile Layout  
1. User opens the application in mobile mode (screen width < 600px)
2. Tools are displayed on the main screen based on visibility settings
3. User taps Settings
4. User navigates to "Tools & Shortcuts" → "Display and arrange tools" 
5. Dialog opens allowing drag-and-drop reordering and toggle visibility
6. Changes are saved automatically
7. User returns to main screen and sees updated tool list

## Technical Details

### State Management
- Uses SharedPreferences for persistent storage
- Tool visibility state is loaded on app startup
- Callback mechanism for real-time updates without app restart

### Tool Configuration
Default tools are defined with metadata:
```dart
ToolConfig(
  id: 'textTemplate',
  nameKey: 'textTemplateGen',
  descKey: 'textTemplateGenDesc', 
  icon: 'description',
  iconColor: 'blue800',
  isVisible: true,
  order: 0,
)
```

### Refresh Mechanism
- Desktop: `_refreshToolSelection()` method updates sidebar immediately
- Mobile: Tools refresh when returning to main screen
- Settings always remains visible regardless of tool visibility

## Files Modified
- `lib/main.dart`: Dynamic tool selection and refresh mechanism
- `lib/screens/main_settings.dart`: Added Tools & Shortcuts section
- `lib/l10n/app_en.arb`: English localization strings
- `lib/l10n/app_vi.arb`: Vietnamese localization strings

## Files Added
- `lib/services/tool_visibility_service.dart`: Core visibility management
- `lib/widgets/tool_visibility_dialog.dart`: UI for managing tools

## Testing Recommendations
1. Test drag-and-drop functionality in the dialog
2. Verify toggle switches work correctly  
3. Test "Reset to default" functionality
4. Verify tools disappear/appear in both desktop and mobile layouts
5. Test with all tools hidden scenario
6. Verify localization in both English and Vietnamese
7. Test real-time refresh when settings change in desktop mode
