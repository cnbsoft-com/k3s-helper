class Mpk3s < Formula
  desc "Multipass 기반 K3s 클러스터 관리 CLI 도구"
  homepage "https://github.com/cnbsoft-com/k3s-helper"
  url "https://github.com/cnbsoft-com/k3s-helper/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  license "MIT"

  depends_on "multipass"

  def install
    # 1. 메인 실행 파일 설치
    bin.install "bin/mpk3s"
    
    # 2. 보조 헬퍼 스크립트 설치
    bin.install "libs/k3s-helper"
    
    # 3. 기타 라이브러리 파일들을 libexec에 보관 (내부 참조용)
    libexec.install Dir["libs/*.sh"]
  end

  test do
    system "#{bin}/mpk3s", "usage"
    system "#{bin}/k3s-helper", "--help"
  end
end
