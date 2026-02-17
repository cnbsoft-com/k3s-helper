class Mpk3s < Formula
  desc "Multipass 기반 K3s 클러스터 관리 CLI 도구"
  homepage "https://github.com/cnbsoft-com/k3s-helper"
  url "https://github.com/cnbsoft-com/k3s-helper/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a8176f92a9b32f80eca266391bc16c7b6093716eb4bd0b2b7a0ea9bafc98ff74"
  license "MIT"

  # depends_on "multipass"

  def install
    # 1. 메인 실행 파일 설치
    bin.install "bin/mpk3s"
  end

  def caveats
    <<~EOS
      이 도구는 'multipass'가 설치되어 있어야 작동합니다.
      만약 설치되어 있지 않다면 아래 명령어로 먼저 설치해 주세요:
        brew install --cask multipass
    EOS
  end

  test do
    system "#{bin}/mpk3s", "usage"
  end
end
