#!/bin/bash

CONFIG_FILE="$HOME/.config/opencode/oh-my-opencode.json"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
BACKUP_FILE="$CONFIG_FILE.backup"

# Free base models
BASE_MODELS=(
    "opencode/glm-4.7-free"
    "opencode/minimax-m2.1-free"
    "opencode/grok-code"
    "opencode/big-pickle"
)

# Free model markers
FREE_MODELS=(
    "opencode/glm-4.7-free"
    "opencode/minimax-m2.1-free"
    "opencode/grok-code"
    "opencode/big-pickle"
)

# Initial MODELS (will be updated dynamically)
MODELS=(
    "opencode/glm-4.7-free"
    "opencode/minimax-m2.1-free"
    "opencode/grok-code"
    "opencode/big-pickle"
    "custom"
)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
NC='\033[0m'

# Initialize model list (load favorites and deduplicate)
get_current_model() {
    if [ -f "$CONFIG_FILE" ]; then
        python3 -c "
import json
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = json.load(f)
        if config.get('agents'):
            first_agent = list(config['agents'].values())[0]
            model = first_agent.get('model', 'unknown')
            print(model)
        else:
            print('unknown')
except:
    print('unknown')
" 2>/dev/null || echo "unknown"
    else
        echo "unknown"
    fi
}

get_opencode_model() {
    if [ -f "$OPENCODE_CONFIG" ]; then
        python3 -c "
import json
try:
    with open('$OPENCODE_CONFIG', 'r') as f:
        config = json.load(f)
        main_model = config.get('model', 'unknown')
        small_model = config.get('small_model', 'unknown')
        print(f'{main_model}|{small_model}')
except:
    print('unknown|unknown')
" 2>/dev/null || echo "unknown|unknown"
    else
        echo "unknown|unknown"
    fi
}

get_favorite_models() {
    local model_file="$HOME/.local/state/opencode/model.json"
    if [ -f "$model_file" ]; then
        python3 -c "
import json
try:
    with open('$model_file', 'r') as f:
        data = json.load(f)
        favorites = data.get('favorite', [])
        for fav in favorites:
            provider = fav.get('providerID', '')
            model = fav.get('modelID', '')
            if model:
                print(f'{provider}/{model}')
except:
    pass
" 2>/dev/null
    fi
}

get_oh_my_opencode_agents() {
    if [ -f "$CONFIG_FILE" ]; then
        python3 -c "
import json
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = json.load(f)
        if config.get('agents'):
            for name, agent_config in config['agents'].items():
                model = agent_config.get('model', 'unknown')
                print(f'{name}|{model}')
except:
    pass
" 2>/dev/null
    fi
}

list_agents() {
    if [ -f "$CONFIG_FILE" ]; then
        python3 -c "
import json
try:
    with open('$CONFIG_FILE', 'r') as f:
        config = json.load(f)
        if config.get('agents'):
            i = 1
            for name in config['agents'].keys():
                print(f'{i}|{name}')
                i += 1
except:
    pass
" 2>/dev/null
    fi
}

# Display single model, add FREE tag if applicable
display_model() {
    local index=$1
    local model=$2

    # Check if model is free
    is_free=false
    for free_model in "${FREE_MODELS[@]}"; do
        if [[ "$model" == "$free_model" ]]; then
            is_free=true
            break
        fi
    done

    if [[ "$is_free" == true ]]; then
        printf "  ${GREEN}%2d)${NC} %s ${BLUE}[FREE]${NC}\n" "$index" "$model"
    else
        printf "  ${GREEN}%2d)${NC} %s\n" "$index" "$model"
    fi
}

show_current() {
    opencode_models=$(get_opencode_model)
    main_model=$(echo "$opencode_models" | cut -d'|' -f1)
    small_model=$(echo "$opencode_models" | cut -d'|' -f2)

    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}   Current model configuration${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}[opencode]${NC}"

    is_main_free=false
    for free_model in "${FREE_MODELS[@]}"; do
        if [[ "$main_model" == "$free_model" ]]; then
            is_main_free=true
            break
        fi
    done

    is_small_free=false
    for free_model in "${FREE_MODELS[@]}"; do
        if [[ "$small_model" == "$free_model" ]]; then
            is_small_free=true
            break
        fi
    done

    if [[ "$is_main_free" == true ]]; then
        echo -e "  ${GREEN}Main model:${NC}   ${main_model} ${BLUE}[FREE]${NC}"
    else
        echo -e "  ${GREEN}Main model:${NC}   ${main_model}"
    fi

    if [[ "$is_small_free" == true ]]; then
        echo -e "  ${GREEN}Small model:${NC}   ${small_model} ${BLUE}[FREE]${NC}"
    else
        echo -e "  ${GREEN}Small model:${NC}   ${small_model}"
    fi
    echo ""
    echo -e "${YELLOW}[oh-my-opencode]${NC}"
    agents_info=$(get_oh_my_opencode_agents)
    if [ -n "$agents_info" ]; then
        while IFS='|' read -r agent_name model; do
            is_free=false
            for free_model in "${FREE_MODELS[@]}"; do
                if [[ "$model" == "$free_model" ]]; then
                    is_free=true
                    break
                fi
            done
            if [[ "$is_free" == true ]]; then
                printf "  ${GREEN}%-25s${NC} %s ${BLUE}[FREE]${NC}\n" "$agent_name:" "$model"
            else
                printf "  ${GREEN}%-25s${NC} %s\n" "$agent_name:" "$model"
            fi
        done <<< "$agents_info"
    else
        echo "  ${RED}No agent configuration${NC}"
    fi
    echo ""
}

# Dynamically update MODELS array, add favorite models (deduplicate)
update_models() {
    FAVORITE_MODELS=($(get_favorite_models))

    NEW_MODELS=()

    # 辅助函数：检查元素是否在数组中
    array_contains() {
        local element="$1"
        shift
        local array=("$@")
        for item in "${array[@]}"; do
            [[ "$item" == "$element" ]] && return 0
        done
        return 1
    }

    # 添加MODELS中的非"custom"模型
    for model in "${MODELS[@]}"; do
        if [[ "$model" != "custom" ]]; then
            if ! array_contains "$model" "${NEW_MODELS[@]}"; then
                NEW_MODELS+=("$model")
            fi
        fi
    done

    # 添加收藏模型（去重）
    for model in "${FAVORITE_MODELS[@]}"; do
        if ! array_contains "$model" "${NEW_MODELS[@]}"; then
            NEW_MODELS+=("$model")
        fi
    done

    # Add custom
    NEW_MODELS+=("custom")

    # Update MODELS
    MODELS=("${NEW_MODELS[@]}")
}

list_models() {
    update_models
    show_current
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}   oh-my-opencode Model list${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available models:${NC}"
                echo ""
                for i in "${!MODELS[@]}"; do
                    display_model $((i+1)) "${MODELS[$i]}"
                done
                echo ""
}

switch_agent_to() {
    local agent_name="$1"
    local model="$2"
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}✗ Configuration filenot found${NC}"
        return 1
    fi

    cp "$CONFIG_FILE" "$BACKUP_FILE"

    python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

if config.get('agents', {}).get('$agent_name'):
    config['agents']['$agent_name']['model'] = '$model'
else:
    print('Agent not found')
    exit(1)

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ [$agent_name] switched to: $model${NC}"
        show_current
    else
        echo -e "${RED}✗ Switch failed or agent not found${NC}"
        cp "$BACKUP_FILE" "$CONFIG_FILE"
    fi
}

switch_to() {
    local model="$1"
    local agent_name="$2"

    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}✗ Configuration filenot found${NC}"
        return 1
    fi

    cp "$CONFIG_FILE" "$BACKUP_FILE"

    if [ -n "$agent_name" ]; then
        # Switch single agent
        python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

if config.get('agents', {}).get('$agent_name'):
    config['agents']['$agent_name']['model'] = '$model'
else:
    print('Agent not found')
    exit(1)

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ [$agent_name] switched to: $model${NC}"
            show_current
        else
            echo -e "${RED}✗ Switch failed or agent not found${NC}"
            cp "$BACKUP_FILE" "$CONFIG_FILE"
        fi
    else
        # Switch all agents (backward compatible)
        python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

for agent in config.get('agents', {}):
    config['agents'][agent]['model'] = '$model'

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ All agents switched to: $model${NC}"
            show_current
        else
            echo -e "${RED}✗ Switch failed${NC}"
            cp "$BACKUP_FILE" "$CONFIG_FILE"
        fi
    fi
}

switch_opencode_model() {
    local model="$1"
    local model_type="$2"

    if [ ! -f "$OPENCODE_CONFIG" ]; then
        echo -e "${RED}✗ opencode Configuration filenot found${NC}"
        return 1
    fi

    local temp_backup="$OPENCODE_CONFIG.backup"
    cp "$OPENCODE_CONFIG" "$temp_backup"

    if [ "$model_type" = "main" ]; then
        # UpdateMain model
        python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['model'] = '$model'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ opencode Main modelswitched to: $model${NC}"
            show_current
        else
            echo -e "${RED}✗ Switch failed${NC}"
            cp "$temp_backup" "$OPENCODE_CONFIG"
        fi
    elif [ "$model_type" = "small" ]; then
        # UpdateSmall model
        python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['small_model'] = '$model'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ opencode Small modelswitched to: $model${NC}"
            show_current
        else
            echo -e "${RED}✗ Switch failed${NC}"
            cp "$temp_backup" "$OPENCODE_CONFIG"
        fi
    fi
}

validate_model_format() {
    local model="$1"
    if [[ ! "$model" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_+.\-]+$ ]]; then
        echo -e "${RED}✗ Error: Model format should be provider/model${NC}"
        echo -e "${YELLOW}Example: opencode/glm-4.7-free, openai/gpt-4${NC}"
        return 1
    fi
    return 0
}

interactive() {
    while true; do
        clear
        show_current

        # Select configuration type
        echo -e "${BLUE}════════════════════════════════════════${NC}"
        echo -e "${BLUE}   Select configuration type${NC}"
        echo -e "${BLUE}════════════════════════════════════════${NC}"
        echo "  1) opencode Main model"
        echo "  2) opencode Small model"
        echo "  3) oh-my-opencode agents"
        echo "  4) All models"
        echo ""

        echo -n -e "${BLUE}Select type [1-4] or q to quit: ${NC}"
        read type_choice

         case $type_choice in
            q|Q) exit 0 ;;
            1)
                update_models
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${BLUE}   oh-my-opencode Model list${NC}"
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available models:${NC}"
                echo ""
                for i in "${!MODELS[@]}"; do
                    display_model $((i+1)) "${MODELS[$i]}"
                done
                echo ""

                echo -n -e "${BLUE}Select model [1-${#MODELS[@]}] or 0 to return: ${NC}"
                read choice
                case $choice in
                    0) continue ;;
                    [1-9]|1[0-9])
                        index=$((choice-1))
                        if [ $index -lt ${#MODELS[@]} ]; then
                            selected="${MODELS[$index]}"
                            if [ "$selected" = "custom" ]; then
                                echo -n -e "${YELLOW}Enter model name: ${NC}"
                                read custom
                                if [ -n "$custom" ]; then
                                    python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['model'] = '$custom'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                    echo -e "${GREEN}✓ opencode Main modelswitched to: $custom${NC}"
                                fi
                            else
                                python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['model'] = '$selected'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                echo -e "${GREEN}✓ opencode Main modelswitched to: $selected${NC}"
                            fi
                        fi
                        ;;
                esac
                 ;;
            2)
                update_models
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${BLUE}   oh-my-opencode Model list${NC}"
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available models:${NC}"
                echo ""
                for i in "${!MODELS[@]}"; do
                    display_model $((i+1)) "${MODELS[$i]}"
                done
                echo ""

                echo -n -e "${BLUE}Select model [1-${#MODELS[@]}] or 0 to return: ${NC}"
                read choice
                case $choice in
                    0) continue ;;
                    [1-9]|1[0-9])
                        index=$((choice-1))
                        if [ $index -lt ${#MODELS[@]} ]; then
                            selected="${MODELS[$index]}"
                            if [ "$selected" = "custom" ]; then
                                echo -n -e "${YELLOW}Enter model name: ${NC}"
                                read custom
                                if [ -n "$custom" ]; then
                                    python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['small_model'] = '$custom'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                    echo -e "${GREEN}✓ opencode Small modelswitched to: $custom${NC}"
                                fi
                            else
                                python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['small_model'] = '$selected'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                echo -e "${GREEN}✓ opencode Small modelswitched to: $selected${NC}"
                            fi
                        fi
                        ;;
                esac
                 ;;
            3)
                update_models
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${BLUE}   oh-my-opencode Model list${NC}"
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available models:${NC}"
                echo ""
                for i in "${!MODELS[@]}"; do
                    display_model $((i+1)) "${MODELS[$i]}"
                done
                echo ""

                # Select target to switch agent
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${BLUE}   Select target Agent${NC}"
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available Agents:${NC}"
                echo ""

                agents_list=$(list_agents)
                agent_count=$(echo "$agents_list" | wc -l)
                i=1
                while IFS='|' read -r num agent_name; do
                    printf "  ${GREEN}%2d)${NC} %s\n" "$num" "$agent_name"
                    i=$((i+1))
                done <<< "$agents_list"
                printf "  ${GREEN}%2d)${NC} %s\n" "0" "All agents"
                echo ""

                echo -n -e "${BLUE}Select Agent [0-$agent_count] or q to quit: ${NC}"
                read agent_choice

                case $agent_choice in
                    q|Q) exit 0 ;;
                    0)
                        target_agent=""
                        echo -e "${GREEN}✓ Will switch all agents${NC}"
                        ;;
                    [1-9]|1[0-9])
                        target_agent=$(echo "$agents_list" | grep "^$agent_choice|" | cut -d'|' -f2)
                        if [ -z "$target_agent" ]; then
                            echo -e "${RED}✗ Invalid selection${NC}"
                            continue
                        fi
                        echo -e "${GREEN}✓ Will switch: $target_agent${NC}"
                        ;;
                    *)
                        echo -e "${RED}✗ Invalid selection${NC}"
                        continue
                        ;;
                esac

                echo ""
                echo -n -e "${BLUE}Select model [1-${#MODELS[@]}] or 0 to return: ${NC}"
                read choice
                case $choice in
                    0) continue ;;
                    [1-9]|1[0-9])
                        index=$((choice-1))
                        if [ $index -lt ${#MODELS[@]} ]; then
                            selected="${MODELS[$index]}"
                            if [ "$selected" = "custom" ]; then
                                echo -n -e "${YELLOW}Enter model name: ${NC}"
                                read custom
                                if [ -n "$custom" ]; then
                                    cp "$CONFIG_FILE" "$BACKUP_FILE"
                                    python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

if '$target_agent':
    config['agents']['$target_agent']['model'] = '$custom'
else:
    for agent in config.get('agents', {}):
        config['agents'][agent]['model'] = '$custom'

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
                                    if [ $? -eq 0 ]; then
                                        if [ -n "$target_agent" ]; then
                                            echo -e "${GREEN}✓ [$target_agent] switched to: $custom${NC}"
                                        else
                                            echo -e "${GREEN}✓ All agents switched to: $custom${NC}"
                                        fi
                                    else
                                        echo -e "${RED}✗ Switch failed${NC}"
                                        cp "$BACKUP_FILE" "$CONFIG_FILE"
                                    fi
                                fi
                            else
                                cp "$CONFIG_FILE" "$BACKUP_FILE"
                                python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)

if '$target_agent':
    config['agents']['$target_agent']['model'] = '$selected'
else:
    for agent in config.get('agents', {}):
        config['agents'][agent]['model'] = '$selected'

with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
                                if [ $? -eq 0 ]; then
                                    if [ -n "$target_agent" ]; then
                                        echo -e "${GREEN}✓ [$target_agent] switched to: $selected${NC}"
                                    else
                                        echo -e "${GREEN}✓ All agents switched to: $selected${NC}"
                                    fi
                                else
                                    echo -e "${RED}✗ Switch failed${NC}"
                                    cp "$BACKUP_FILE" "$CONFIG_FILE"
                                fi
                            fi
                        fi
                        ;;
                esac
                ;;
            4)
                update_models
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${BLUE}   oh-my-opencode Model list${NC}"
                echo -e "${BLUE}════════════════════════════════════════${NC}"
                echo -e "${YELLOW}Available models:${NC}"
                echo ""
                for i in "${!MODELS[@]}"; do
                    display_model $((i+1)) "${MODELS[$i]}"
                done
                echo ""

                echo -n -e "${BLUE}Select model [1-${#MODELS[@]}] or 0 to return: ${NC}"
                read choice
                case $choice in
                    0) continue ;;
                    [1-9]|1[0-9])
                        index=$((choice-1))
                        if [ $index -lt ${#MODELS[@]} ]; then
                            selected="${MODELS[$index]}"
                            if [ "$selected" = "custom" ]; then
                                echo -n -e "${YELLOW}Enter model name: ${NC}"
                                read custom
                                if [ -n "$custom" ]; then
                                    # Switch opencode Main model andSmall model
                                    cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.backup"
                                    python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['model'] = '$custom'
config['small_model'] = '$custom'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                    # SwitchAll oh-my-opencode agents
                                    cp "$CONFIG_FILE" "$BACKUP_FILE"
                                    python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)
for agent in config.get('agents', {}):
    config['agents'][agent]['model'] = '$custom'
with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
                                    if [ $? -eq 0 ]; then
                                        echo -e "${GREEN}✓ All modelsswitched to: $custom${NC}"
                                    else
                                        echo -e "${RED}✗ Switch failed${NC}"
                                        cp "$BACKUP_FILE" "$CONFIG_FILE"
                                        cp "$OPENCODE_CONFIG.backup" "$OPENCODE_CONFIG"
                                    fi
                                fi
                            else
                                # Switch opencode Main model andSmall model
                                cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.backup"
                                python3 -c "
import json
with open('$OPENCODE_CONFIG', 'r') as f:
    config = json.load(f)
config['model'] = '$selected'
config['small_model'] = '$selected'
with open('$OPENCODE_CONFIG', 'w') as f:
    json.dump(config, f, indent=4, ensure_ascii=False)
" 2>/dev/null
                                # SwitchAll oh-my-opencode agents
                                cp "$CONFIG_FILE" "$BACKUP_FILE"
                                python3 -c "
import json
with open('$CONFIG_FILE', 'r') as f:
    config = json.load(f)
for agent in config.get('agents', {}):
    config['agents'][agent]['model'] = '$selected'
with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
" 2>/dev/null
                                if [ $? -eq 0 ]; then
                                    echo -e "${GREEN}✓ All modelsswitched to: $selected${NC}"
                                else
                                    echo -e "${RED}✗ Switch failed${NC}"
                                    cp "$BACKUP_FILE" "$CONFIG_FILE"
                                    cp "$OPENCODE_CONFIG.backup" "$OPENCODE_CONFIG"
                                fi
                            fi
                        fi
                        ;;
                esac
                ;;
            *)
                echo -e "${RED}✗ Invalid selection${NC}"
                ;;
        esac
    done
}

case "$1" in
    --list|-l) list_models ;;
    --agent)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo -e "${RED}✗ Usage: $0 --agent <agent_name> <model>${NC}"
            exit 1
        fi
        switch_to "$3" "$2"
        ;;
    --main-model)
        if [ -z "$2" ]; then
            echo -e "${RED}✗ Usage: $0 --main-model <model>${NC}"
            exit 1
        fi
        switch_opencode_model "$2" "main"
        ;;
    --small-model)
        if [ -z "$2" ]; then
            echo -e "${RED}✗ Usage: $0 --small-model <model>${NC}"
            exit 1
        fi
        switch_opencode_model "$2" "small"
        ;;
    --help|-h)
        echo "Usage: $0 [options] [model]"
        echo "  --list                  List all models"
        echo "  --agent <name> <model>  Switch specified oh-my-opencode agent"
        echo "  --main-model <model>    Switch opencode Main model"
        echo "  --small-model <model>   Switch opencode Small model"
        echo "  --version               Show version"
        echo "  --help                  Show help"
        echo "  model name                Switch all oh-my-opencode agents (format: provider/model)"
        exit 0
        ;;
    --version)
        echo "opencode-switch-model v1.0.0"
        exit 0
        ;;
    "") interactive ;;
    *)
        if validate_model_format "$1"; then
            switch_to "$1"
        else
            exit 1
        fi
        ;;
esac

