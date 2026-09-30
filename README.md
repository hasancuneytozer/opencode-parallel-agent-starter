# OpenCode paralel agent başlangıç projesi

Bu iskelet Architect'i ana agent yapar. Frontend ve Backend ayrı Git worktree'lerinde çalışır. Reviewer değişiklikleri okur ve bulguları Architect'e bildirir.

## Klasörler

```text
.opencode/agents/       Frontend, Backend ve Reviewer tanımları
scripts/                İki Git worktree'sini hazırlayan betik
opencode.jsonc          Architect ve worktree klasörü ayarı
```

## Kurulum adımları

1. Bu klasörde Git deposunu başlatıp ilk commit'i oluşturun:

   ```powershell
   git init
   git add .
   git commit -m "Add OpenCode parallel agent starter"
   ```

   Git kullanıcı adınız veya e-posta adresiniz ayarlı değilse Git'in önerdiği `git config` komutlarıyla bir kez ayarlayın.

2. İki çalışma klasörünü oluşturun:

   ```powershell
   .\scripts\create-worktrees.ps1
   ```

   Varsayılan konum proje içindeki `.worktrees\frontend` ve `.worktrees\backend` klasörleridir.
   Klasörleri yanlışlıkla sildiyseniz aynı komutu tekrar çalıştırabilirsiniz. Betik kalan Git kayıtlarını temizler ve mevcut branch'lerden klasörleri yeniden açar. Commit edilmemiş değişiklikler silinen klasörden geri getirilemez.

3. Architect oturumunu bu proje klasöründe başlatın:

   ```powershell
   opencode
   ```

   Yeni oturumlarda varsayılan agent `architect` olur.

4. Her worker için ayrı terminal açıp ilgili klasörde OpenCode'u başlatın:

   ```powershell
   Set-Location .worktrees\frontend
   opencode --agent frontend
   ```

   ```powershell
   Set-Location .worktrees\backend
   opencode --agent backend
   ```

   Architect'in verdiği görevleri ilgili oturuma yapıştırın. İki oturum farklı Git worktree'lerinde paralel çalışır.

5. Worker'lar kendi branch'lerine commit attıktan sonra Architect ana klasörde `work/frontend` ve `work/backend` branch'lerini inceler ve birleştirir. Ardından `@reviewer` çağrısıyla birleşik değişiklikleri gözden geçirir.

## İlk deneme

Architect'e küçük bir özellik verin ve frontend ile backend taraflarında bağımsız görevler oluşturmasını isteyin. Worker görevlerini ayrı oturumlara atayın; tamamlanınca Architect'e dönüp sonuçları entegre etmesini ve Reviewer'ı çalıştırmasını söyleyin.

Agent tanımları OpenCode V2'nin `.opencode/agents/` Markdown biçimini kullanır. `mode: primary` worker'ların kendi oturumlarında seçilebilmesini sağlar; worktree yalıtımını worker oturumunu o worktree klasöründe başlatarak elde edersiniz.
