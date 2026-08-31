import xml.etree.ElementTree as ET
import os

def generate_summary():
    xml_file = 'results/output.xml'
    if not os.path.exists(xml_file):
        print(f"Error: {xml_file} not found. Cannot generate summary.")
        return
        
    try:
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        # Robot Framework output.xml stats structure
        # <statistics>
        #   <total>
        #     <stat pass="X" fail="Y">All Tests</stat>
        #   </total>
        # </statistics>
        total_stat = root.find('.//statistics/total/stat')
        if total_stat is None:
            print("Warning: Could not parse statistics from output.xml")
            return
            
        passed = int(total_stat.attrib.get('pass', 0))
        failed = int(total_stat.attrib.get('fail', 0))
        skip = int(total_stat.attrib.get('skip', 0))
        total = passed + failed + skip
        
        pass_rate = (passed / (passed + failed) * 100) if (passed + failed) > 0 else 0
        
        summary_file = os.environ.get('GITHUB_STEP_SUMMARY')
        if not summary_file:
            print("Warning: GITHUB_STEP_SUMMARY environment variable not set. Printing to stdout instead.")
            # Fallback to printing
            print(f"Total: {total}, Passed: {passed}, Failed: {failed}, Pass Rate: {pass_rate:.1f}%")
            return
            
        with open(summary_file, 'a', encoding='utf-8') as f:
            f.write("## 🧪 Relatório de Saúde da Pipeline de Testes\n\n")
            
            # Status badge
            if failed == 0:
                f.write("> ### 🟢 STATUS: SUCESSO\n")
                f.write("> Todos os testes críticos executaram e passaram com sucesso na esteira.\n\n")
            else:
                f.write(f"> ### 🔴 STATUS: FALHA ({failed} falhas detectadas)\n")
                f.write("> Atenção! Alguns testes falharam no pipeline. Verifique os logs e artefatos anexados.\n\n")
            
            f.write("### 📊 Métricas de Execução\n\n")
            f.write("| Dimensão | Métrica | Valor |\n")
            f.write("| --- | --- | --- |\n")
            f.write(f"| 📋 **Total** | Casos de teste mapeados | {total} |\n")
            f.write(f"| ✅ **Sucesso** | Testes passados | {passed} ({pass_rate:.1f}%) |\n")
            f.write(f"| ❌ **Falhas** | Testes falhados | {failed} |\n")
            if skip > 0:
                f.write(f"| 🟡 **Ignorados** | Testes skipped | {skip} |\n")
            
            # Additional metadata
            f.write("\n### 🔍 Detalhes Adicionais\n")
            f.write("- **Framework:** Robot Framework\n")
            f.write("- **Camadas:** API (GraphQL) e E2E (Playwright)\n")
            f.write("- **Relatório Completo:** Baixe o arquivo `robot-framework-results` nos artefatos desta execução para abrir o `report.html` interativo.\n")
            
    except Exception as e:
        print(f"Error parsing xml or writing summary: {e}")

if __name__ == '__main__':
    generate_summary()
