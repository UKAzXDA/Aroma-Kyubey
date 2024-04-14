<img src="https://raw.githubusercontent.com/UKAzXDA/UKAz-XDA/main/20240414_031804.jpg">

# Aroma-Kyubey  Version 3.00b1

Aroma-Kyubey é uma ferramenta criada para a instalação de ROMs, que oferece uma interface touch personalizável para que os usuários possam escolher as opções de instalação de acordo com suas necessidades. Este aplicativo otimiza o processo de instalação, removendo a necessidade de limpeza manual de partições, criação de vendor ou configuração manual do Aroma.

## Processo de Instalação

### Verificação de Compatibilidade com o Modelo
- **Incompatível**: Nenhuma ação será realizada.
- **Compatível**: A instalação prosseguirá.

### Verificação da Partição do Vendor
- **Dependência do Vendor**: Se não houver partição do vendor, a ferramenta criará uma. Este processo inclui um wipe data e wipe system automático, resultando na perda dos dados.
- **Independência do Vendor**: Esta etapa será ignorada.

### Verificação do Volume das Imagens
- Aroma-Kyubey verificará se o sistema possui o tamanho ideal. Caso contrário, será realizada uma repartição conforme o valor recomendado pela ROM, incluindo o vendor se a ROM for compatível com Treble. Este processo exigirá que o usuário faça manualmente format data.. "yes" apos o reboot, resultando na perda total de dados do sdcard, system, data e etc..

### Pós-instalação das Imagens
- Aroma-Kyubey procurará o arquivo build.prop na imagem. Se não encontrar, isso indica que a imagem foi corrompida. Aroma-Kyubey então notificará o instalador e o Aroma sobre o erro, evitando o wipe data e outras configurações personalizadas, e iniciará a correção das imagens antes de concluir a instalação com erro. Este processo não é garantido, e pode ser necessário reinstalar sua ROM anterior para recuperar seus dados e configurações. Por isso, recomenda-se evitar formatar ou limpar partições desnecessariamente, já que a Aroma-Kyubey gerenciará ou solicitará estas ações quando necessário. Desta forma, mesmo em caso de erro ao final do processo, sua ROM e dados anteriores serão preservados.

### Compatibilidade
- Compatível com as variantes do TWRP-v3.XX e Orangefox.
