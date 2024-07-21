{pkgs, ...}: {
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    cheese
    eog
    gnome-calendar
    cheese # webcam tool
    gnome-terminal
    gnome.gnome-weather
    gnome.gnome-music
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome.gnome-maps
    gnome-font-viewer
    gnome.gnome-logs
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    totem # video player
    loupe
    simple-scan
    snapshot
    yelp
    gnome-text-editor
    gnome-connections
  ];
}
