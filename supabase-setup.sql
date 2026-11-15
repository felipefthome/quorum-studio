-- QUORUM STUDIO · configuração do Supabase (rode uma vez no SQL Editor)
-- Antes de rodar: troque SEU_EMAIL_AQUI (no fim do arquivo) pelo e-mail que você vai usar para entrar no app.

create table if not exists public.membros (
  email text primary key,
  papel text not null default 'membro' check (papel in ('admin','membro'))
);
create table if not exists public.edificios (id uuid primary key, data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.imoveis   (id uuid primary key, data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.identidade(id int  primary key, data jsonb not null, updated_at timestamptz not null default now());

create or replace function public.is_member() returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.membros where lower(email) = lower(auth.jwt()->>'email'))
$$;
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.membros where lower(email) = lower(auth.jwt()->>'email') and papel = 'admin')
$$;

alter table public.membros    enable row level security;
alter table public.edificios  enable row level security;
alter table public.imoveis    enable row level security;
alter table public.identidade enable row level security;

drop policy if exists "membros: ver o proprio acesso" on public.membros;
create policy "membros: ver o proprio acesso" on public.membros for select to authenticated
  using (lower(email) = lower(auth.jwt()->>'email') or public.is_admin());

-- edifícios e imóveis: membros leem, criam e editam; só admin exclui
do $$ declare t text; begin
  foreach t in array array['edificios','imoveis'] loop
    execute format('drop policy if exists "ler" on public.%I', t);
    execute format('drop policy if exists "criar" on public.%I', t);
    execute format('drop policy if exists "editar" on public.%I', t);
    execute format('drop policy if exists "excluir" on public.%I', t);
    execute format('create policy "ler" on public.%I for select to authenticated using (public.is_member())', t);
    execute format('create policy "criar" on public.%I for insert to authenticated with check (public.is_member())', t);
    execute format('create policy "editar" on public.%I for update to authenticated using (public.is_member()) with check (public.is_member())', t);
    execute format('create policy "excluir" on public.%I for delete to authenticated using (public.is_admin())', t);
  end loop;
end $$;

-- identidade da marca: membros leem; só admin altera
drop policy if exists "ler" on public.identidade;
drop policy if exists "criar" on public.identidade;
drop policy if exists "editar" on public.identidade;
create policy "ler" on public.identidade for select to authenticated using (public.is_member());
create policy "criar" on public.identidade for insert to authenticated with check (public.is_admin());
create policy "editar" on public.identidade for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- fotos (bucket privado)
insert into storage.buckets (id, name, public) values ('fotos', 'fotos', false) on conflict (id) do nothing;
drop policy if exists "fotos: ler" on storage.objects;
drop policy if exists "fotos: enviar" on storage.objects;
drop policy if exists "fotos: excluir" on storage.objects;
create policy "fotos: ler" on storage.objects for select to authenticated using (bucket_id = 'fotos' and public.is_member());
create policy "fotos: enviar" on storage.objects for insert to authenticated with check (bucket_id = 'fotos' and public.is_member());
create policy "fotos: excluir" on storage.objects for delete to authenticated using (bucket_id = 'fotos' and public.is_admin());

-- você como administrador (troque pelo seu e-mail, em minúsculas)
insert into public.membros (email, papel) values (lower('SEU_EMAIL_AQUI'), 'admin')
  on conflict (email) do update set papel = 'admin';
