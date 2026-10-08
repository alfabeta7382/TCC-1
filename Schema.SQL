-- Rode no Supabase: SQL Editor > New query > Run

create table usuarios (
  id uuid primary key default gen_random_uuid(),
  matricula text unique not null,
  nome text not null,
  turma text,
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

create table livros (
  id uuid primary key default gen_random_uuid(),
  titulo text not null,
  autor text,
  quantidade int not null default 1 check (quantidade >= 0),
  criado_em timestamptz not null default now()
);

create table visitas (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid not null references usuarios(id) on delete cascade,
  entrada timestamptz not null default now(),
  saida timestamptz
);

create table emprestimos (
  id uuid primary key default gen_random_uuid(),
  livro_id uuid not null references livros(id) on delete cascade,
  usuario_id uuid not null references usuarios(id) on delete cascade,
  retirada timestamptz not null default now(),
  devolucao timestamptz
);

create index on visitas (entrada);
create index on emprestimos (retirada);

-- Segurança: só usuários logados (bibliotecários) acessam os dados
alter table usuarios enable row level security;
alter table livros enable row level security;
alter table visitas enable row level security;
alter table emprestimos enable row level security;

create policy "staff" on usuarios for all to authenticated using (true) with check (true);
create policy "staff" on livros for all to authenticated using (true) with check (true);
create policy "staff" on visitas for all to authenticated using (true) with check (true);
create policy "staff" on emprestimos for all to authenticated using (true) with check (true);