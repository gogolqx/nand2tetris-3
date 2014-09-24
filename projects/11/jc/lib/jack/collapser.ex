defmodule Jack.Collapser do
  def collapse(ast) do
    {ast, _counts} = collapse(ast, %{ifs: 0, whiles: 0})
    ast
  end

  def collapse([{:ifStatement, statement}|tail], %{ifs: count}=counts) do
    {condition, statement} = condition(statement)
    {true_statements, statement} = statements(statement)
    {true_statements, counts} = collapse(true_statements, %{counts | ifs: count+1})
    {else_or_empty, []} = else_or_empty(statement)
    {else_or_empty, counts} = collapse(else_or_empty, counts)
    map = %{
      index: count,
      condition: condition,
      true_statements: true_statements,
      false_statements: else_or_empty,
    }
    {tail,counts} = collapse(tail,counts)
    {[{:ifStatement, map}|tail], counts}
  end
  def collapse([{:whileStatement, statement}|tail], %{whiles: count}=counts) do
    {condition, statement} = condition(statement)
    {statements, []} = statements(statement)
    {statements, counts} = collapse(statements, %{counts | whiles: count+1})
    map = %{
      index: count,
      condition: condition,
      statements: statements }
    {tail, counts} = collapse(tail, counts)
    {[{:whileStatement, map}|tail], counts}
  end
  def collapse([{:subroutineDec, dec}|tail], counts) do
    counts = %{counts | ifs: 0, whiles: 0} #rest counts per subroutine
    {dec, counts} = collapse(dec, counts)
    {tail, counts} = collapse(tail, counts)
    {[{:subroutineDec,dec}|tail],counts}
  end
  def collapse([],counts), do: {[], counts}
  def collapse([{type,list}|tail],counts) when is_list(list) do
    {list, counts} = collapse(list, counts)
    {tail, counts} = collapse(tail, counts)
    {[{type,list}|tail], counts}
  end
  def collapse([head|tail],counts) do
    {tail, counts} = collapse(tail,counts)
    {[head|tail], counts}
  end

  defp condition([{:keyword,"if"},{:symbol,"("},{:expression,exp},{:symbol,")"}| tail]) do
    {exp, tail}
  end
  defp condition([{:keyword,"while"},{:symbol,"("},{:expression,exp},{:symbol,")"}| tail]) do
    {exp, tail}
  end

  defp statements([{:symbol,"{"},{:statements,st},{:symbol,"}"}|tail]) do
    {st, tail}
  end

  defp else_or_empty([{:keyword,"else"}|tail]), do: statements(tail)
  defp else_or_empty([]), do: {[],[]}
end
