{
  pkgs,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    spiceUSBRedirection.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
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

  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
  services.qemuGuest.enable = true;
}
