# QUORUM STUDIO

Gerador de artes para Instagram da Quorum Imóveis (post, carrossel e Stories).

Site estático: basta o `index.html` e o `logo-quorum.png` na mesma pasta.

- Fora do claude.ai, o download dos PNG/ZIP é direto pelo navegador.
- A biblioteca (edifícios, imóveis e fotos) fica salva no navegador de cada aparelho.
  Para levar de um aparelho a outro: Biblioteca → Exportar backup (.zip) → Importar backup no outro.
- Limpar os dados do navegador apaga a biblioteca daquele aparelho: faça backups.

## Biblioteca da equipe (Supabase) — acesso único

1. Crie um projeto no supabase.com.
2. No SQL Editor, rode `supabase-setup.sql` (troque `SEU_EMAIL_AQUI` pelo e-mail da equipe).
3. Em Authentication → Users → Add user → Create new user: o mesmo e-mail + uma senha forte, com "Auto Confirm User" marcado.
4. Preencha `config.js` com a Project URL, a Publishable key e o e-mail da equipe.
5. No app, Biblioteca → digite a senha da equipe → Entrar (uma vez por aparelho).
