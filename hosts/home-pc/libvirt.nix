{
  pkgs,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
  };

  # virtualisation = {
  #   libvirtd = {
  #     enable = true;
  #     qemu = {
  #       swtpm.enable = true;
  #       ovmf.enable = true;
  #       ovmf.packages = [pkgs.OVMFFull.fd];
  #     };
  #   };
  #   spiceUSBRedirection.enable = true;
  # };
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
  services.qemuGuest.enable = true;
  # services.davfs2 = {
  #   enable = true;
  #   settings = ''
  #     ask_auth 0
  #   '';
  # };
  # fileSystems = {
  #   "/root/myshare" = {
  #     device = "http://localhost:9843/myshare";
  #     fsType = "davfs";
  #     options = ["nofail"];
  #   };
  # };
}
