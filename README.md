# QUORUM STUDIO

Gerador de artes para Instagram da Quorum Imóveis (post, carrossel e Stories).

Site estático: basta o `index.html` e o `logo-quorum.png` na mesma pasta.

- Fora do claude.ai, o download dos PNG/ZIP é direto pelo navegador.
- A biblioteca (edifícios, imóveis e fotos) fica salva no navegador de cada aparelho.
  Para levar de um aparelho a outro: Biblioteca → Exportar backup (.zip) → Importar backup no outro.
- Limpar os dados do navegador apaga a biblioteca daquele aparelho: faça backups.

## Biblioteca da equipe (Supabase)

1. Crie um projeto no supabase.com.
2. No SQL Editor, rode `supabase-setup.sql` (troque `SEU_EMAIL_AQUI` pelo e-mail do administrador).
3. Cole a Project URL e a Publishable key em `config.js`.
4. No app, use "Criar acesso" / "Entrar" na seção Biblioteca.
5. Para incluir alguém: Table Editor → `membros` → nova linha com o e-mail (minúsculas) e papel `membro` ou `admin`.

Membros cadastram e editam; só `admin` exclui e altera a identidade da marca.
