# Usar uma imagem oficial do Python como base
FROM python:3.9-slim

# Definir o diretório de trabalho no contentor
WORKDIR /app

# Copiar os ficheiros de requisitos (vamos criar um em branco por agora)
COPY requirements.txt .

# Instalar as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o resto da aplicação
COPY . .

# Expor a porta 80
EXPOSE 80

# Comando para correr a aplicação
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]