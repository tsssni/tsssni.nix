import Hyprland from "gi://AstalHyprland"
import { Variable } from 'astal'
import { Widget, Astal, Gdk } from 'astal/gtk3'
import { bind } from 'astal/binding'

const hyprland = Hyprland.get_default()

class WindowManager {
	clients = Variable(hyprland.get_clients())
	activeClient = Variable(hyprland.get_focused_client())
	activeWorkspace = Variable(hyprland.get_focused_workspace())
	
	constructor() {
		hyprland.connect('client-added', () => {
			this.clients.set(hyprland.get_clients())
		})
		
		hyprland.connect('client-removed', () => {
			this.clients.set(hyprland.get_clients())
		})
		
		hyprland.connect('notify::focused-client', () => {
			this.activeClient.set(hyprland.get_focused_client())
		})

		hyprland.connect('notify::focused-workspace', () => {
			this.activeWorkspace.set(hyprland.get_focused_workspace())
		})
	}
}

const windowManager = new WindowManager()

function getIconForClient(client: Hyprland.Client): string {
    const default_icon = "application-x-executable";
    
    if (!client.class) return default_icon;
    
    let iconInfo = Astal.Icon.lookup_icon(client.class);
    if (iconInfo) {
        return client.class;
    }
    
    const lowerClass = client.class.toLowerCase();
    iconInfo = Astal.Icon.lookup_icon(lowerClass);
    if (iconInfo) {
        return lowerClass;
    }
    
    const titleCase = lowerClass.charAt(0).toUpperCase() + lowerClass.slice(1);
    iconInfo = Astal.Icon.lookup_icon(titleCase);
    if (iconInfo) {
        return titleCase;
    }
    
    const normalized = client.class.replace(/[^a-zA-Z0-9]/g, '');
    iconInfo = Astal.Icon.lookup_icon(normalized);
    if (iconInfo) {
        return normalized;
    }
    
    if (client.class.includes('-') || client.class.includes('.')) {
        const parts = client.class.split(/[-\.]/);
        
        // Try each part individually
        for (const part of parts) {
            if (part.length > 3) { // Only try meaningful parts
                iconInfo = Astal.Icon.lookup_icon(part);
                if (iconInfo) {
                    return part;
                }
            }
        }
    }
    
    return default_icon;
}

function WindowIcon(client: Hyprland.Client) {
	const isHovered = Variable(false)
	const iconName = getIconForClient(client)
	
	const icon = new Widget.Button({
		className: bind(Variable.derive([windowManager.activeClient, isHovered], (activeClient, hovered) => {
			let name = 'icon'
			if (activeClient && activeClient.address === client.address) name += ' active'
            if (hovered) name += ' hovered'
            return name
		})),
		child: new Widget.Icon({
			icon: iconName,
		}),
		onClicked: () => {
			hyprland.dispatch('focuswindow', `address:0x${client.address}`)
		},
		setup: (self) => {
			self.connect('enter-notify-event', () => {
				isHovered.set(true)
			})
			self.connect('leave-notify-event', () => {
				isHovered.set(false)
			})
		},
	})
	
	return icon
}

export default new Widget.EventBox({
	child: new Widget.Box({
		className: 'icon',
		children: bind(Variable.derive(
			[windowManager.clients, windowManager.activeWorkspace],
			(clients: any[], activeWorkspace: any) => 
				clients
				.filter(client => client.mapped && client.workspace.id === activeWorkspace.id)
				.sort((a, b) => a.x - b.x)
				.map(client => WindowIcon(client))
		)),
		spacing: 4,
	}),
})
